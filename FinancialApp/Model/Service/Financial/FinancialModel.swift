//
//  FinancialModel.swift
//  Beecher
//
//  Created by 정성윤 on 2024/07/24.
//

import Foundation

//현재 환율
struct FinancialModel : Hashable, Codable {
    let result : Int? //결과
    let cur_unit : String? //통화코드
    let cur_nm : String? //국가/통화명
    let ttb  : String? //전신환(송금) 받을때
    let tts : String? //전신환(송금) 보낼때
    let deal_bas_r : String? //매매 기준율
    let bkpr : String? //장부 가격
    let yy_efee_r : String? //년환가료율
    let ten_dd_efee_r : String? //10일환가료율
    let kftc_deal_bas_r : String? //서울외국환중개 매매기준율
    let kftc_bkpr : String? //서울외국환중개 장부가격
}
//대출 금리
struct LoanModel : Hashable, Codable {
    let result : Int?
    let sfln_intrc_nm : String? //대출기간
    let int_r : String? //고정기준금리
}
//국제 금리
struct InternationalModel : Hashable, Codable {
    let result : Int?
    let cur_fund : String? //통화
    let sfln_intrc_nm : String? //기간
    let int_r : String? //금리
}
