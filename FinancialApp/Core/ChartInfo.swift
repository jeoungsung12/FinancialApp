//
//  ChartInfo.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/24.
//

import Foundation
//TODO: - Hide
let ChartInfo : String = "<Useful patterns to buy> 1. High and dense flag pattern: A stock with a continuous upward trend reaches its highest point, then gradually declines within 15 days, forming a curved peak. 2. Pipe Bottom Type: A pattern that is highly probable after a long-term decline in stock prices for more than six months and is not a frequently seen pattern, but the rate of increase is large enough to compete for first or second place. 3. Reversal rising scallop pattern: The overall shape of the chart resembles a scallop swimming in the sea, and the width of the pattern continues to narrow as the stock price rises. 4. Triple rising bottom type: The triple rising bottom type refers to a form that adds to the W pattern, hits another bottom, and forms three lows. 5. Round bottom type: When the stock price passes a long-term downtrend and rises again in a round U-shape and enters a slightly downtrend near the previous high point, use the timing of the upward departure as a buying position. 6. Declining triangle: The high points fall continuously, the low points fall gently, and in the process of falling, the high points and low points meet to create a triangle shape. 7. W pattern: In the W pattern, the second low point must be higher than the first low point, and the more gradual the angle of the falling point is, the more positive the investor's perspective is, so the slope of the second falling point is higher than the first falling point. It is better if it is gentle."

// 패턴 이미지 매칭
let patterns = [
       "High and dense flag pattern": "high",
       "Pipe Bottom Type": "pipe",
       "Reversal rising scallop pattern": "rising",
       "Triple rising bottom type": "triple",
       "Round bottom type": "round",
       "Declining triangle": "triangle",
       "W pattern": "w",
       "(High and dense flag pattern)": "high",
       "(Pipe Bottom Type)": "pipe",
       "(Reversal rising scallop pattern)": "rising",
       "(Triple rising bottom type)": "triple",
       "(Round bottom type)": "round",
       "(Declining triangle)": "triangle",
       "(W pattern)": "w"
   ]
