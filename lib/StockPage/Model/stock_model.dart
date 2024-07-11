import 'dart:convert';

class StockBasisModel {
  String name;
  List<OneQuarter> parameters;

  StockBasisModel({required this.name, required this.parameters});

  toMap() {
    return {
      'name': name,
      'parameters': jsonEncode(parameters.map((e) => e.toMap()).toList())
    };
  }

  static StockBasisModel fromMap(Map<String, dynamic> map) {
    return StockBasisModel(
        name: map['name'],
        parameters: (jsonDecode(map['parameters']) as List)
            .map((e) => OneQuarter.fromMap(e))
            .toList());
  }
}

class OneQuarter {
  String date;
  int numberStocks;
  int shortAsset;
  int money;
  int inventory;
  int totalDebt;
  int totalQuarterRevenue;
  int totalCost;
  int profit;
  int financialRevenue;
  int financialCost;
  int companyManagementCost;
  int profitAfterTax;
  int price;
  double dividend;
  double? realPrice;
  double? profitEfficiency;
  double? managementEfficiency;

  OneQuarter(
      {required this.date,
      required this.price,
      required this.companyManagementCost,
      required this.financialCost,
      required this.financialRevenue,
      required this.inventory,
      required this.money,
      required this.numberStocks,
      required this.profit,
      required this.profitAfterTax,
      required this.shortAsset,
      required this.totalCost,
      required this.totalDebt,
      required this.totalQuarterRevenue,
      required this.dividend});

  toMap() {
    return {
      'date': date,
      'price': price,
      'companyManagementCost': companyManagementCost,
      'financialCost': financialCost,
      'financialRevenue': financialRevenue,
      'inventory': inventory,
      'money': money,
      'numberStocks': numberStocks,
      'profit': profit,
      'profitAfterTax': profitAfterTax,
      'shortAsset': shortAsset,
      'totalCost': totalCost,
      'totalDebt': totalDebt,
      'totalQuarterRevenue': totalQuarterRevenue,
      'dividend': dividend,
      'realPrice': realPrice ?? 0,
      'profitEfficiency': profitEfficiency ?? 0,
      'managementEfficiency': managementEfficiency ?? 0
    };
  }

  static OneQuarter fromMap(Map<String, dynamic> map) {
    return OneQuarter(
        date: map['date'],
        price: map['price'] ?? 0,
        companyManagementCost: map['companyManagementCost'] ?? 0,
        financialCost: map['financialCost'] ?? 0,
        financialRevenue: map['financialRevenue'] ?? 0,
        inventory: map['inventory'] ?? 0,
        money: map['money'] ?? 0,
        numberStocks: map['numberStocks'] ?? 0,
        profit: map['profit'] ?? 0,
        profitAfterTax: map['profitAfterTax'] ?? 0,
        shortAsset: map['shortAsset'] ?? 0,
        totalCost: map['totalCost'] ?? 0,
        totalDebt: map['totalDebt'] ?? 0,
        totalQuarterRevenue: map['totalQuarterRevenue'] ?? 0,
        dividend: map['dividend'] ?? 0);
  }
}

class StockModel {
  List<OneDay> price;
  String name;

  StockModel({required this.price, required this.name});

  toMap() {
    return {
      'price': jsonEncode(price.map((e) => e.toMap()).toList()),
      'name': name,
    };
  }

  static StockModel fromMap(Map<String, dynamic> stockModel) {
    return StockModel(
      price: (jsonDecode(stockModel['price']) as List)
          .map((e) => OneDay.fromMap(e))
          .toList(),
      name: stockModel['name'],
    );
  }
}

class OneDay {
  String date;
  double openPrice;
  double closePrice;
  double highestPrice;
  double lowestPrice;
  double normalPrice;
  double priceChange;
  double priceChangeByPercent;
  int volumeTotal;
  int valueTotal;
  int marketValue;
  double? smaValue;
  double? smaPrice;
  int? sell;
  String? status;
  int? totalPeriodBuy;
  int? totalVolumeBuy;

  @override
  int get hashCode => Object.hash(
      date,
      openPrice,
      closePrice,
      highestPrice,
      lowestPrice,
      normalPrice,
      priceChange,
      priceChangeByPercent,
      volumeTotal,
      valueTotal,
      marketValue);

  OneDay(
      {required this.date,
      required this.openPrice,
      required this.closePrice,
      required this.highestPrice,
      required this.lowestPrice,
      required this.normalPrice,
      required this.priceChange,
      required this.priceChangeByPercent,
      required this.volumeTotal,
      required this.valueTotal,
      required this.marketValue,
      this.smaValue,
      this.smaPrice,
      this.sell,
      this.totalPeriodBuy,
      this.totalVolumeBuy});

  static OneDay fromMap(Map<String, dynamic> oneDay) {
    return OneDay(
        date: oneDay['date'],
        openPrice: oneDay['openPrice'] ?? 0,
        closePrice: oneDay['closePrice'] ?? 0,
        highestPrice: oneDay['highestPrice'] ?? 0,
        lowestPrice: oneDay['lowestPrice'] ?? 0,
        normalPrice: oneDay['normalPrice'] ?? 0,
        priceChange: oneDay['priceChange'] ?? 0,
        priceChangeByPercent: oneDay['priceChangeByPercent'] ?? 0,
        volumeTotal: oneDay['volumeTotal'] ?? 0,
        valueTotal: oneDay['valueTotal'] ?? 0,
        marketValue: oneDay['marketValue'] ?? 0,
        smaPrice: oneDay['smaPrice'] ?? 0,
        smaValue: oneDay['smaValue'] ?? 0,
        totalVolumeBuy: oneDay['totalVolumeBuy'] ?? 0,
        sell: oneDay['sell'] ?? 0);
  }

  toMap() {
    return {
      'date': date,
      'openPrice': openPrice,
      'closePrice': closePrice,
      'highestPrice': highestPrice,
      'lowestPrice': lowestPrice,
      'normalPrice': normalPrice,
      'priceChange': priceChange,
      'priceChangeByPercent': priceChangeByPercent,
      'volumeTotal': volumeTotal,
      'valueTotal': valueTotal,
      'marketValue': marketValue,
      'smaPrice': smaPrice ?? 0,
      'smaValue': smaValue ?? 0,
      'sell': sell ?? 0,
      'totalVolumeBuy': totalVolumeBuy ?? 0
    };
  }

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other;
  }
}
