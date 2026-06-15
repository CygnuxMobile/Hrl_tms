import 'dart:convert';

String quickDocketSubmitToJson(QuickDocketSubmit data) =>
    json.encode(data.toJson());

class QuickDocketSubmit {
  final String dockdt;
  final String partYCode;
  final String partyName;
  final String orgncd;
  final String paybas;
  final String currFinYear;
  final String baseCompanyCode;
  final String destcd;
  final String dockno;
  final String baseUserName;
  final String transPortModel;
  final String pincode;
  final String toCity;
  final String fromCity;
  final String volYn;
  final String csgncd;
  final String csgnm;
  final String csgnAdd;
  final String csgecd;
  final String csgenm;
  final String csgeAdd;
  final String toPincode;
  final List<DocketInvoiceList> docketInvoiceList;

  QuickDocketSubmit({
    required this.dockdt,
    required this.partYCode,
    required this.partyName,
    required this.orgncd,
    required this.paybas,
    required this.currFinYear,
    required this.baseCompanyCode,
    required this.destcd,
    required this.dockno,
    required this.baseUserName,
    required this.transPortModel,
    required this.pincode,
    required this.toCity,
    required this.fromCity,
    required this.volYn,
    required this.csgncd,
    required this.csgnm,
    required this.csgnAdd,
    required this.csgecd,
    required this.csgenm,
    required this.csgeAdd,
    required this.toPincode,
    required this.docketInvoiceList,
  });

  Map<String, dynamic> toJson() => {
        "dockdt": dockdt,
        "partY_CODE": partYCode,
        "party_name": partyName,
        "orgncd": orgncd,
        "paybas": paybas,
        "currFinYear": currFinYear,
        "baseCompanyCode": baseCompanyCode,
        "destcd": destcd,
        "dockno": dockno,
        "baseUserName": baseUserName,
        "transPortModel": transPortModel,
        "pincode": pincode,
        "toCity": toCity,
        "vol_yn": volYn,
        "csgncd": csgncd,
        "csgnm": csgnm,
        "csgnAdd": csgnAdd,
        "csgecd": csgecd,
        "csgenm": csgenm,
        "csgeAdd": csgeAdd,
        "fromCity": fromCity,
        "toPincode": toPincode,
        "docketInvoiceList":
            List<dynamic>.from(docketInvoiceList.map((x) => x.toJson())),
      };
}

class DocketInvoiceList {
  final String invno;
  final String prodcd;
  final String pkgsty;
  final int pkgs;
  final double decval;
  final double actuwt;
  final double chrgwt;
  final String ewbno;
  final double voLL;
  final double voLB;
  final double voLH;
  String ?eWayBillExpiredDate;
  String ?eWayBillInvoiceDate;
  final String image;

  DocketInvoiceList({
    required this.invno,
    required this.prodcd,
    required this.pkgsty,
    required this.pkgs,
    required this.decval,
    required this.actuwt,
    required this.chrgwt,
    required this.ewbno,
    required this.voLL,
    required this.voLB,
    required this.voLH,
    this.eWayBillExpiredDate,
    this.eWayBillInvoiceDate,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
        "invno": invno,
        "prodcd": prodcd,
        "pkgsty": pkgsty,
        "pkgs": pkgs,
        "decval": decval,
        "actuwt": actuwt,
        "chrgwt": chrgwt,
        "ewbno": ewbno,
        "voL_L": voLL,
        "voL_B": voLB,
        "voL_H": voLH,
        "eWayBillExpiredDate": eWayBillExpiredDate ?? null,
        "eWayBillInvoiceDate": eWayBillInvoiceDate ?? null,
        "image": image,
      };
}
