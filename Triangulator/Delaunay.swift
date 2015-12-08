//
//  Delaunay.swift
//  Triangulator
//
//  Created by Łukasz Adamczak on 19.06.2015.
//  Copyright (c) 2015 Łukasz Adamczak.
//
//  Triangulator is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//

import Foundation

let EPSILON: CGFloat = 1.0 / 1048576.0

public typealias Triangle = (i: Int, j: Int, k: Int)
typealias Circumcircle = (i: Int, j: Int, k: Int, x: CGFloat, y: CGFloat, r: CGFloat)

func supertriangle(vertices: [NSPoint]) -> [NSPoint] {
    var xmin = CGFloat.infinity
    var ymin = CGFloat.infinity
    var xmax = -CGFloat.infinity
    var ymax = -CGFloat.infinity
    
    for vertex in vertices {
        if vertex.x < xmin { xmin = vertex.x }
        if vertex.x > xmax { xmax = vertex.x }
        if vertex.y < ymin { ymin = vertex.y }
        if vertex.y > ymax { ymax = vertex.y }
    }
    
    let dx = xmax - xmin
    let dy = ymax - ymin
    let dmax = max(dx, dy)
    let xmid = xmin + dx * 0.5
    let ymid = ymin + dy * 0.5
    
    return [
        NSPoint(x: xmid - 20 * dmax, y: ymid -      dmax),
        NSPoint(x: xmid            , y: ymid + 20 * dmax),
        NSPoint(x: xmid + 20 * dmax, y: ymid -      dmax)
    ]
}

func circumcircle(vertices: [NSPoint], i: Int, j: Int, k: Int) -> Circumcircle {
    let x1 = vertices[i].x,
    y1 = vertices[i].y,
    x2 = vertices[j].x,
    y2 = vertices[j].y,
    x3 = vertices[k].x,
    y3 = vertices[k].y,
    fabsy1y2 = abs(y1 - y2),
    fabsy2y3 = abs(y2 - y3)
    var xc, yc, m1, m2, mx1, mx2, my1, my2, dx, dy: CGFloat
    
    // Check for coincident points
    if fabsy1y2 < EPSILON && fabsy2y3 < EPSILON {
        fatalError("Error: coincident points")
    }
    
    if fabsy1y2 < EPSILON {
        m2  = -((x3 - x2) / (y3 - y2))
        mx2 = (x2 + x3) / 2.0
        my2 = (y2 + y3) / 2.0
        xc  = (x2 + x1) / 2.0
        yc  = m2 * (xc - mx2) + my2
    }
    else if fabsy2y3 < EPSILON  {
        m1  = -((x2 - x1) / (y2 - y1))
        mx1 = (x1 + x2) / 2.0
        my1 = (y1 + y2) / 2.0
        xc  = (x3 + x2) / 2.0
        yc  = m1 * (xc - mx1) + my1
    }
    else {
        m1  = -((x2 - x1) / (y2 - y1))
        m2  = -((x3 - x2) / (y3 - y2))
        mx1 = (x1 + x2) / 2.0
        mx2 = (x2 + x3) / 2.0
        my1 = (y1 + y2) / 2.0
        my2 = (y2 + y3) / 2.0
        xc  = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2)
        yc  = (fabsy1y2 > fabsy2y3) ?
            m1 * (xc - mx1) + my1 :
            m2 * (xc - mx2) + my2
    }
    
    dx = x2 - xc
    dy = y2 - yc
    
    return (i: i, j: j, k: k, x: xc, y: yc, r: dx * dx + dy * dy)
}

// expected
// before: [5,3,3,0,0,5,2,5,5,0,0,2,4,5,5,2,2,4]
// after: [5,3,3,0,0,2,4,5,2,4]
func dedup(inout edges: [Int]) {
    for var j = edges.count; j > 0; {
        // Z powodu usuwania elementów z iterowanej tablicy
        // taki dodatkowy warunek jest potrzebny.
        // W javaskrypcie pobierał undefined i się nie martwił.
        if j > edges.count {
            j = j - 2
            continue
        }
        
        let b = edges[--j]
        let a = edges[--j]
        
        for var i = j; i > 0; {
            let n = edges[--i]
            let m = edges[--i]
            
            if (a == m && b == n) || (a == n && b == m) {
                edges.removeAtIndex(j)
                edges.removeAtIndex(j)
                edges.removeAtIndex(i)
                edges.removeAtIndex(i)
                break
            }
        }
    }
}

public func triangulate(var vertices: [NSPoint]) -> [Triangle] {
    let n = vertices.count
    
    // Za mało punktów do triangulacji
    if n < 3 {
        return []
    }
    
    // Startowa tablica indeksów
    // NOTE: Tutaj porównanie moze być do poprawki (<= zamiast <)
    //       Ale to się dopiero okaże
    var indices = Array<Int>(0..<n)
    indices.sortInPlace { vertices[$1].x < vertices[$0].x }
    
    // Znaleźć "supertriangle"
    // => [[-1900,0],[100,2100],[2100,0]]
    let st = supertriangle(vertices)
    vertices.appendContentsOf(st)
    
    // Nie wiem jeszcze jakie typy tych tablic
    // => {"i":3,"j":4,"k":5,"x":99.99999999999994,"y":97.6190476190477,"r":4009529.4784580497}
    var open = [circumcircle(vertices, i: n + 0, j: n + 1, k: n + 2)]
    var closed: [Circumcircle] = []
    var edges: [Int] = []
    
    // NOTE: Tu jeszcze opróżnia tablicę edges na końcu iteracji
    for var i = indices.count; i-- > 0; edges.removeAll() {
        let c = indices[i]
        
        for var j = open.count; j-- > 0; {
            // If this point is to the right of this triangle's circumcircle,
            // then this triangle should never get checked again. Remove it
            // from the open list, add it to the closed list, and skip.
            let dx = vertices[c].x - open[j].x
            if dx > 0.0 && dx * dx > open[j].r {
                // TODO: Te 2 linie można w jednej linijce
                closed.append(open[j])
                open.removeAtIndex(j)
                continue
            }
            
            // If we're outside the circumcircle, skip this triangle.
            let dy = vertices[c].y - open[j].y;
            if dx * dx + dy * dy - open[j].r > EPSILON {
                continue
            }
            
            // Remove the triangle and add it's edges to the edge list.
            // TODO: Tu też można ładniej - najpierw remove, a potem extend
            edges.appendContentsOf([
                open[j].i, open[j].j,
                open[j].j, open[j].k,
                open[j].k, open[j].i
                ])
            open.removeAtIndex(j)
        }
        
        // remove any doubled edges
        dedup(&edges)
        
        // Add a new triangle for each edge.
        for var j = edges.count; j > 0; {
            let b = edges[--j]
            let a = edges[--j]
            open.append(circumcircle(vertices, i: a, j: b, k: c))
        }
    }
    
    for var i = open.count; i-- > 0; {
        closed.append(open[i])
    }
    
    var res: [Triangle] = []
    for var i = closed.count; i-- > 0; {
        if closed[i].i < n && closed[i].j < n && closed[i].k < n {
//            res.extend([closed[i].i, closed[i].j, closed[i].k])
            res.append((i: closed[i].i, j: closed[i].j, k: closed[i].k) )
        }
    }
    
    return res
}