import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:elabv01/StockPage/Blocs/stock_event.dart';
import 'package:elabv01/StockPage/Blocs/stock_state.dart';
import 'package:elabv01/repository/database_helper.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/stock_model.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  StockBloc()
      : super(StockState([],
            price: [],
            listOrderByVolume: [],
            listOrderByMoneyFlow: [],
            listOrderBySharpIncrease: [],
            listOrderByBasicParameter: [],
            showHighVolumeInPeriod: false,
            showHighValueInDay: false,
            showHighVolumeInDayThanPrevious: false,
            showBasicList: false,
            showStockPrice: false,
            dataRows: [],
            xUserLabels: [],
            dataRowsLegends: [])) {
    on<StockEventAdd>(addStock);
    on<StockEventLoadAll>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      await queryAllStock();
      //print("xong query");
      await queryAllStockBasis();
      //   printBasisFile();
      printCurrentPrices(priceStocks: prices, title: "stock prices ");
      //    if (prices.last.price.length > 5)
      {
        if (kDebugMode) {
          print("vao day 1");
        }
        detectSell();
      }

      if (kDebugMode) {
        print("emit state");
      }
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
    on<StockEventImportFile>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      await importFileExcel(event, emit);
      await queryAllStock();
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
    on<StockEventImportBasisFile>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      await importBasisFile(event, emit);
    });
    on<StockEventCopyDB>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: [],
          stockStatus: []));
      await copyDB();
    });
    on<StockEventDeleteDB>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      await deleteDB(event, emit);
    });
    on<StockEventRestoreDB>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      await restoreDB(event, emit);
    });

    on<StockEventShowDetail>((event, emit) async {
      emit(StockStateLoading(
        [],
        price: [],
        listOrderByVolume: [],
        listOrderByMoneyFlow: [],
        listOrderBySharpIncrease: [],
        listOrderByBasicParameter: [],
        showHighVolumeInPeriod: false,
        showHighValueInDay: false,
        showHighVolumeInDayThanPrevious: false,
        showBasicList: false,
        showStockPrice: false,
        dataRows: [],
        xUserLabels: [],
        dataRowsLegends: [],
      ));
      await showDetail(event, emit);
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
    on<StockEventShowHighVolumeInPeriod>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      showHighVolumeInPeriod = !showHighVolumeInPeriod;
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
    on<StockEventShowBasicList>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      showBasicList = !showBasicList;
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
    on<StockEventShowStockPrice>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      showStockPrice = !showStockPrice;
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
    on<StockEventShowHighValueInDay>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      showHighValueInDay = !showHighValueInDay;
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
    on<StockEventShowHighVolumeInDayThanPrevious>((event, emit) async {
      emit(StockStateLoading([],
          price: [],
          listOrderByVolume: [],
          listOrderByMoneyFlow: [],
          listOrderBySharpIncrease: [],
          listOrderByBasicParameter: [],
          showHighVolumeInPeriod: false,
          showHighValueInDay: false,
          showHighVolumeInDayThanPrevious: false,
          showBasicList: false,
          showStockPrice: false,
          dataRows: [],
          xUserLabels: [],
          dataRowsLegends: []));
      showHighVolumeInDayThanPrevious = !showHighVolumeInDayThanPrevious;
      emit(StockStateLoaded(listStockShowDetails,
          price: prices,
          listOrderByVolume: listOrderByVolume,
          listOrderByMoneyFlow: listOrderByMoneyFlow,
          listOrderBySharpIncrease: listOrderBySharpIncrease,
          listOrderByBasicParameter: listOrderByBasicParameter,
          showHighVolumeInPeriod: showHighVolumeInPeriod,
          showBasicList: showBasicList,
          showHighValueInDay: showHighValueInDay,
          showHighVolumeInDayThanPrevious: showHighVolumeInDayThanPrevious,
          showStockPrice: showStockPrice,
          dataRows: dataRows,
          xUserLabels: xUserLabels,
          dataRowsLegends: dataRowsLegends,
          stockStatus: stockStatus));
    });
  }

  List<StockModel> prices = [];
  List<OneDay> listStockShowDetails = [];
  List<StockModel> listOrderByVolume = [];
  List<StockModel> listOrderByMoneyFlow = [];
  List<StockModel> listOrderBySharpIncrease = [];
  List<List<double>> dataRows = [];
  List<String> xUserLabels = [];
  List<String> dataRowsLegends = [];
  Map<String, List<OneDay>> priceMap = {};
  Map<String, List<OneQuarter>> stockBasisMap = {};
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<StockModel> oneDayPrices = [];
  List<String>? stockStatus = [];
  int numberOfDays = 8;
  List<StockBasisModel> basicParameterList = [];
  List<StockBasisModel> listOrderByBasicParameter = [];
  List<StockBasisModel> importBasisList = [];
  bool showBasicList = false;
  bool showHighVolumeInPeriod = false;
  bool showHighValueInDay = false;
  bool showHighVolumeInDayThanPrevious = false;
  bool showStockPrice = false;

  Future<void> addStock(
      StockEventAdd event, Emitter<StockState> emitter) async {
    bool checked = false;
    try {
      prices = await databaseHelper.queryAllStockPrice();
      List<StockModel> updatePrices = event.price;
      for (StockModel updatePrice in updatePrices) {
        // int stockPosition = -1;
        for (StockModel price in prices) {
          // stockPosition++;
          if (price.name == updatePrice.name) {
            checked = true;
            break;
          }
        }
        if (!checked) {
          databaseHelper.insertStockPrice(updatePrice);
        }
      }
    } catch (e) {
      return;
    }
  }

  void updateListBasicByRealPrice(StockBasisModel stockModel) {
    int position = -1;
    for (int i = 0; i < listOrderByBasicParameter.length; i++) {
      if (stockModel.parameters[stockModel.parameters.length - 1].realPrice! <
          listOrderByBasicParameter[i]
              .parameters[listOrderByBasicParameter[i].parameters.length - 1]
              .realPrice!) {
        position++;
      } else {
        break;
      }
    }
    if (((position == -1) && (listOrderByBasicParameter.isEmpty)) ||
        (position == listOrderByBasicParameter.length - 1)) {
      listOrderByBasicParameter.add(stockModel);
      return;
    }
    if (position < listOrderByBasicParameter.length - 1) {
      listOrderByBasicParameter.add(StockBasisModel(parameters: [], name: ''));
      for (int i = listOrderByBasicParameter.length - 1;
          i > (position + 1);
          i--) {
        listOrderByBasicParameter[i] = listOrderByBasicParameter[i - 1];
      }
      listOrderByBasicParameter[position + 1] = stockModel;
    }
  }

  Future<List<StockBasisModel>> queryAllStockBasis() async {
    try {
      stockBasisMap = {};
      basicParameterList = await databaseHelper.queryAllStockBasis();
      for (var basicParameter in basicParameterList) {
        for (var oneQuarter in basicParameter.parameters) {
          oneQuarter.realPrice =
              (oneQuarter.shortAsset - oneQuarter.totalDebt) /
                  (oneQuarter.numberStocks * oneQuarter.price);
          oneQuarter.profitEfficiency = ((oneQuarter.profitAfterTax * 10) /
              oneQuarter.totalQuarterRevenue);
          oneQuarter.managementEfficiency = oneQuarter.totalQuarterRevenue /
              (oneQuarter.companyManagementCost * 100);
        }
        stockBasisMap.addAll({basicParameter.name: basicParameter.parameters});
        updateListBasicByRealPrice(basicParameter);
      }
      return basicParameterList;
    } catch (e) {
      return [];
    }
  }

  void updateListOrderBySharpIncrease(StockModel stockModel) {
    int position = -1;
    for (int i = 0; i < listOrderBySharpIncrease.length; i++) {
      if (stockModel.price[stockModel.price.length - 1].valueTotal <
          listOrderBySharpIncrease[i]
              .price[listOrderBySharpIncrease[i].price.length - 1]
              .valueTotal) {
        position++;
      } else {
        break;
      }
    }
    if (((position == -1) && (listOrderBySharpIncrease.isEmpty)) ||
        (position == listOrderBySharpIncrease.length - 1)) {
      listOrderBySharpIncrease.add(stockModel);
      return;
    }
    if (position < listOrderBySharpIncrease.length - 1) {
      listOrderBySharpIncrease.add(StockModel(price: [], name: ''));
      for (int i = listOrderBySharpIncrease.length - 1;
          i > (position + 1);
          i--) {
        listOrderBySharpIncrease[i] = listOrderBySharpIncrease[i - 1];
      }
      listOrderBySharpIncrease[position + 1] = stockModel;
    }
  }

  void updateListOrderByMoneyFlow(StockModel stockModel) {
    int position = -1;
    for (int i = 0; i < listOrderByMoneyFlow.length; i++) {
      if (stockModel.price[stockModel.price.length - 1].valueTotal <
          listOrderByMoneyFlow[i]
              .price[listOrderByMoneyFlow[i].price.length - 1]
              .valueTotal) {
        position++;
      } else {
        break;
      }
    }
    if (((position == -1) && (listOrderByMoneyFlow.isEmpty)) ||
        (position == listOrderByMoneyFlow.length - 1)) {
      listOrderByMoneyFlow.add(stockModel);
      return;
    }
    if (position < listOrderByMoneyFlow.length - 1) {
      listOrderByMoneyFlow.add(StockModel(price: [], name: ''));
      for (int i = listOrderByMoneyFlow.length - 1; i > (position + 1); i--) {
        listOrderByMoneyFlow[i] = listOrderByMoneyFlow[i - 1];
      }
      listOrderByMoneyFlow[position + 1] = stockModel;
    }
  }

  void updateListOrderByVolume(StockModel stockModel) {
    int position = -1;
    for (int i = 0; i < listOrderByVolume.length; i++) {
      if (stockModel.price[stockModel.price.length - 1].totalVolumeBuy! <
          listOrderByVolume[i]
              .price[listOrderByVolume[i].price.length - 1]
              .totalVolumeBuy!) {
        position++;
      } else {
        break;
      }
    }
    if (((position == -1) && (listOrderByVolume.isEmpty)) ||
        (position == listOrderByVolume.length - 1)) {
      listOrderByVolume.add(stockModel);
      return;
    }
    if (position < listOrderByVolume.length - 1) {
      listOrderByVolume.add(StockModel(price: [], name: ''));
      for (int i = listOrderByVolume.length - 1; i > (position + 1); i--) {
        listOrderByVolume[i] = listOrderByVolume[i - 1];
      }
      listOrderByVolume[position + 1] = stockModel;
    }
  }

  void updateListPrices(StockModel stockModel) {
    for (var oneDay in stockModel.price) {
      int position = 0;
      bool update = false;
      bool insert = false;
      // for (int j =0;j< priceMap[stockModel.name]!.length;j++) {
      //   OneDay oneDayMap = priceMap[stockModel.name]![j];
      //   if(DateTime
      //       .tryParse(oneDayMap.date)==null){
      //     priceMap[stockModel.name]!.removeAt(j);
      //     break;
      //   }
      for (var oneDayMap in priceMap[stockModel.name]!) {
        // if (kDebugMode) {
        //   print(
        //       '${DateTime.parse(oneDay.date).millisecondsSinceEpoch} ${DateTime.parse(oneDayMap.date).millisecondsSinceEpoch}');
        // }
        if (DateTime.parse(oneDay.date).millisecondsSinceEpoch <
            DateTime.parse(oneDayMap.date).millisecondsSinceEpoch) {
          insert = true;
          break;
        } else if (DateTime.parse(oneDay.date).millisecondsSinceEpoch ==
            DateTime.parse(oneDayMap.date).millisecondsSinceEpoch) {
          // position++;
          update = true;
          break;
        } else {
          position++;
        }
      }
      // if (kDebugMode) {
      //   print(
      //       "vi tri cần chen $position ${stockModel.name} ${priceMap[stockModel.name]!.length}");
      // }
      if (insert && position < priceMap[stockModel.name]!.length) {
        // if (kDebugMode) {
        //   print(
        //       "vi tri chen ${position.toString() + priceMap[stockModel.name]!.toString()}");
        // }
        priceMap[stockModel.name]!.add(priceMap[stockModel.name]!.last);
        if (priceMap[stockModel.name]!.length > 1) {
          for (int i = priceMap[stockModel.name]!.length - 1;
              i > position;
              i--) {
            priceMap[stockModel.name]![i] =
                priceMap[stockModel.name]!.elementAt(i - 1);
            // if (kDebugMode) {
            //   print(
            //       "da dich vi tri ${i.toString() + priceMap[stockModel.name]!.toString()}");
            // }
          }
        }
        priceMap[stockModel.name]![position] = oneDay;
        if (priceMap[stockModel.name]!.length>2*numberOfDays+1){
         // print("da xoa");
          priceMap[stockModel.name]!.removeAt(0);
       //   priceMap[stockModel.name]!.removeAt(1);
        }
        databaseHelper.updateStock(StockModel(
            name: stockModel.name, price: priceMap[stockModel.name]!));
        // if (kDebugMode) {
        //   print(
        //       "chen vao giưa ${position.toString() + priceMap[stockModel.name]!.toString()}");
        // }
      }
      else if (update) {
        if (position > -1) {
          if (priceMap[stockModel.name]!.length - 1 >= position + 1) {
            //dung sai vi tri
            if (DateTime.parse(priceMap[stockModel.name]![position].date)
                    .millisecondsSinceEpoch >=
                DateTime.parse(priceMap[stockModel.name]![position + 1].date)
                    .millisecondsSinceEpoch) {
              priceMap[stockModel.name]?.removeAt(position);
            }
          } else {
            if (kDebugMode) {
              print('updating ${stockModel.name} $position');
            }
            priceMap[stockModel.name]?[position] = oneDay;
            for (int l = position + 1;
                l < priceMap[stockModel.name]!.length;
                l++) {
              if (priceMap[stockModel.name]?[l].date == oneDay.date) {
                priceMap[stockModel.name]?.removeAt(l);
                if (kDebugMode) {
                  print('updating da xoa ${stockModel.name} $position');
                }
              }
            }
          }
        }

        databaseHelper.updateStock(StockModel(
            name: stockModel.name, price: priceMap[stockModel.name]!));
      } else if (position == priceMap[stockModel.name]!.length) {
        if (kDebugMode) {
          print('add stock ${stockModel.name} $position');
        }
        priceMap[stockModel.name]?.add(oneDay);
        databaseHelper.updateStock(StockModel(
            name: stockModel.name, price: priceMap[stockModel.name]!));
      }
    }
  }

  void detectSell() {
    int totalNumberDown = 0;
    listOrderByVolume = [];
    priceMap.forEach((key, value) {
      int totalBuy = 0;
      int totalVolumeBuy = 0;

      int totalSell = 0;
      if (value.length > numberOfDays) {
        for (int i = value.length - numberOfDays; i < value.length; i++) {
          if (value[i].priceChangeByPercent > 0) {
            totalBuy = totalBuy + value[i].valueTotal;
            totalVolumeBuy = totalVolumeBuy + value[i].volumeTotal;
          } else if (value[i].priceChangeByPercent < 0) {
            totalSell = totalSell + value[i].valueTotal;
            totalVolumeBuy = totalVolumeBuy - value[i].volumeTotal;
          }
        }
      }

      if (totalBuy < totalSell) totalNumberDown++;
      if (kDebugMode) {
        print(
            "ma $key : ${totalBuy - totalSell} gia tri mua $totalBuy gia tri ban $totalSell, tong khoi luong mua $totalVolumeBuy");
        value[value.length - 1].totalVolumeBuy = totalVolumeBuy;
        updateListOrderByVolume(StockModel(price: value, name: key));
      }
    });
    if (kDebugMode) {
      print("tong so ma giam $totalNumberDown");
    }
  }

  Future<List<StockModel>> queryAllStock() async {
    try {
      priceMap.clear();
      prices = await databaseHelper.queryAllStockPrice();
      for (StockModel stockModel in prices) {
        priceMap.addAll({stockModel.name: stockModel.price});
      }
      int totalAllMarket = 0;
      int i;
      double totalValuePeriod;
      double totalPricePeriod;
      // print("vao dot bien trong ngay");
      priceMap.forEach((key, value) {
        // print("ma $key");
        value[value.length - 1].smaValue = 0;
        value[value.length - 1].smaPrice = 0;
        totalValuePeriod = 0;
        totalPricePeriod = 0;
        if (value.length > numberOfDays) {
          for (i = value.length - numberOfDays; i < (value.length - 1); i++) {
            totalValuePeriod = totalValuePeriod + value[i].valueTotal;
            totalPricePeriod = totalPricePeriod + value[i].normalPrice;
            //print("gia tri them vao ${value[i].valueTotal} tro thanh $totalValuePeriod");
          }
        }
        value[value.length - 1].smaValue = totalValuePeriod;
        value[value.length - 1].smaPrice = totalPricePeriod / numberOfDays;
        totalAllMarket = totalAllMarket + value[value.length - 1].valueTotal;
        if (value[value.length - 1].closePrice >
            value[value.length - 1].smaPrice!) {
          if ((value[value.length - 1].valueTotal *
                  numberOfDays /
                  value[value.length - 1].smaValue! /
                  value[value.length - 1].smaValue!) >
              value[value.length - 1].priceChangeByPercent) {
            value[value.length - 1].status = "Phân phối";
          } else {
            value[value.length - 1].status = " Tăng";
          }
        } else {
          if (value[value.length - 1].valueTotal >
              value[value.length - 1].smaValue!) {
            value[value.length - 1].status = " Đảo chiều";
          } else {
            value[value.length - 1].status = " Giảm";
          }
        }
        if (value[value.length - 1].smaValue! <
            value[value.length - 1].valueTotal) {
          value[value.length - 1].sell = 1;
          // if (kDebugMode) {
          //   print(
          //       "Co phieu nen mua $key tong khop lenh truoc do ${value[value.length - 1].smaValue!} khoi uong hom nay ${value[value.length - 1].valueTotal}");
          // }
          updateListOrderBySharpIncrease(StockModel(price: value, name: key));
        }
      });
      // print("vao gia tri lon nhat trong ngay");
      // if (kDebugMode) {
      //   print("tong khoi luong giao dich $totalAllMarket");
      // }
      priceMap.forEach((key, value) {
        if (value[value.length - 1].valueTotal > 0.01 * totalAllMarket) {
          // if (kDebugMode) {
          //   print("Co phieu dong tien $key");
          //
          // }
          updateListOrderByMoneyFlow(StockModel(price: value, name: key));
        }
      });
      if (kDebugMode) {
        print("ket thuc query all Stock");
      }
      return prices;
    } catch (e) {
      return [];
    }
  }

  void printCurrentPrices(
      {required List<StockModel> priceStocks,
      int? size,
      required String title}) {
    if (kDebugMode) {
      print(title);
    }
    int i = 0;
    for (var oneDayPrice in priceStocks) {
      if (size != null) {
        i++;
        if (i == size) {
          return;
        }
      }
      if (kDebugMode) {
        print(oneDayPrice.name);
      }
      for (var oneDayStock in oneDayPrice.price) {
        if (kDebugMode) {
          print('${oneDayStock.toMap()}');
        }
      }
    }
  }

  void printBasisFile() {
    if (kDebugMode) {
      print("all stock basic");
    }
    for (var basicParameter in basicParameterList) {
      if (kDebugMode) {
        print(basicParameter.name);
      }
      for (var basicParameterStock in basicParameter.parameters) {
        if (kDebugMode) {
          print('${basicParameterStock.toMap()} ');
        }
      }
    }
  }

  void printOneDayPrices() {
    if (kDebugMode) {
      print("all stock import prices");
    }
    for (var oneDayPrice in oneDayPrices) {
      if (kDebugMode) {
        print(oneDayPrice.name);
      }
      for (var oneDayStock in oneDayPrice.price) {
        if (kDebugMode) {
          print('${oneDayStock.toMap()} ');
        }
      }
    }
  }

  void updateBasisFile(StockBasisModel stockBasisModel) {
    for (var oneQuarter in stockBasisModel.parameters) {
      int position = -1;
      bool update = false;
      for (var oneQuarterMap in stockBasisMap[stockBasisModel.name]!) {
        // if (kDebugMode) {
        //   print(
        //       '${DateTime.parse(oneQuarter.date).millisecondsSinceEpoch} ${DateTime.parse(oneQuarterMap.date).millisecondsSinceEpoch}');
        // }
        if (DateTime.parse(oneQuarter.date).millisecondsSinceEpoch <
            DateTime.parse(oneQuarterMap.date).millisecondsSinceEpoch) {
          break;
        }
        if (DateTime.parse(oneQuarter.date).millisecondsSinceEpoch ==
            DateTime.parse(oneQuarterMap.date).millisecondsSinceEpoch) {
          position++;
          update = true;
          break;
        } else {
          position++;
        }
      }
      // if (kDebugMode) {
      //   print('${stockBasisModel.name} $position');
      // }
      if (update) {
        stockBasisMap[stockBasisModel.name]?[position] = oneQuarter;
        databaseHelper.updateStockBasis(StockBasisModel(
            name: stockBasisModel.name,
            parameters: stockBasisMap[stockBasisModel.name]!));
      } else if (position == stockBasisMap[stockBasisModel.name]!.length) {
        stockBasisMap[stockBasisModel.name]?.add(oneQuarter);
        databaseHelper.updateStockBasis(StockBasisModel(
            name: stockBasisModel.name,
            parameters: stockBasisMap[stockBasisModel.name]!));
      }
    }
  }

  Future<void> importBasisFile(
      StockEventImportBasisFile event, Emitter<StockState> emitter) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    File? file;
    if (result != null) {
      importBasisList = [];
      try {
        file = File(result.files.single.path!);
        var bytes = File(file.path).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        int rowNumber = 0;
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            rowNumber++;
            if (rowNumber > 1) {
              importBasisList.add(
                StockBasisModel(
                  name: row[0]!.value.toString(),
                  parameters: [
                    OneQuarter(
                      date: row[1]!.value.toString(),
                      numberStocks: int.tryParse(row[2]!.value.toString()) ?? 0,
                      shortAsset: int.tryParse(row[3]!.value.toString()) ?? 0,
                      money: int.tryParse(row[4]!.value.toString()) ?? 0,
                      inventory: int.tryParse(row[5]!.value.toString()) ?? 0,
                      totalDebt: int.tryParse(row[6]!.value.toString()) ?? 0,
                      totalQuarterRevenue:
                          int.tryParse(row[7]!.value.toString()) ?? 0,
                      totalCost: int.tryParse(row[8]!.value.toString()) ?? 0,
                      profit: int.tryParse(row[9]!.value.toString()) ?? 0,
                      financialRevenue:
                          int.tryParse(row[10]!.value.toString()) ?? 0,
                      financialCost:
                          int.tryParse(row[11]!.value.toString()) ?? 0,
                      companyManagementCost:
                          int.tryParse(row[12]!.value.toString()) ?? 0,
                      profitAfterTax:
                          int.tryParse(row[13]!.value.toString()) ?? 0,
                      price: int.tryParse(row[14]!.value.toString()) ?? 0,
                      dividend: double.tryParse(row[15]!.value.toString()) ?? 0,
                    ),
                  ],
                ),
              );
            }
          }
        }
      } catch (e) {
        log(e.toString());
      }

      printBasisFile();
      //chen du lieu vào database
      for (var importBasisStock in importBasisList) {
        if (kDebugMode) {
          print("kiem tra ${importBasisStock.name}");
        }
        if (stockBasisMap.containsKey(importBasisStock.name)) {
          // đang co du lieu
          if (kDebugMode) {
            print("dang co ${importBasisStock.name}");
          }
          updateBasisFile(importBasisStock);
          await queryAllStockBasis();
        } else {
          //không có dư liệu
          if (kDebugMode) {
            print("khong co ${importBasisStock.name}");
          }
          await databaseHelper.insertStockBasis(importBasisStock);
          await queryAllStockBasis();
        }
      }
    }
  }

  Future<void> importFileExcel(
      StockEventImportFile event, Emitter<StockState> emitter) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    File? file;
    if (result != null) {
      oneDayPrices = [];
      if (kDebugMode) {
        print(result.files.single.path!);
      }
      try {
        file = File(result.files.single.path!);
        var bytes = File(file.path).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        int rowNumber = 0;
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            rowNumber++;
            if (rowNumber >= 17) {
              oneDayPrices
                  .add(StockModel(name: row[3]!.value.toString(), price: [
                OneDay(
                    date: row[2]!.value.toString(),
                    openPrice: double.tryParse(row[5]!.value.toString()) ?? 0,
                    closePrice: double.tryParse(row[6]!.value.toString()) ?? 0,
                    highestPrice:
                        double.tryParse(row[7]!.value.toString()) ?? 0,
                    lowestPrice: double.tryParse(row[8]!.value.toString()) ?? 0,
                    normalPrice: double.tryParse(row[9]!.value.toString()) ?? 0,
                    priceChange:
                        double.tryParse(row[10]!.value.toString()) ?? 0,
                    priceChangeByPercent:
                        double.tryParse(row[11]!.value.toString()) ?? 0,
                    volumeTotal: int.tryParse(row[12]!.value.toString()) ?? 0,
                    valueTotal:
                        (double.tryParse(row[13]!.value.toString()) ?? 0)
                            .round(),
                    marketValue: int.tryParse(row[18]!.value.toString()) ?? 0)
              ]));
            }
          }
           printOneDayPrices();

          ///
          ///  //chen du lieu vào database
          for (var oneDayPrice in oneDayPrices) {
            // if (kDebugMode) {
            //   print("kiem tra ${oneDayPrice.name}");
            // }
            if (priceMap.containsKey(oneDayPrice.name)) {
              //  đang co du lieu
              // if (kDebugMode) {
              //   print("dang co ${oneDayPrice.name}");
              // }
              updateListPrices(oneDayPrice);
              //   await queryAllStock();
            } else {
              //không có dư liệu
              // if (kDebugMode) {
              //   print("khong co ${oneDayPrice.name}");
              // }
              await databaseHelper.insertStockPrice(oneDayPrice);
              //   await queryAllStock();
            }
          }
          oneDayPrices = [];
          //
        }
      } catch (e) {
        log(e.toString());
      }
      copyDB();
      await queryAllStock();
  //    if (prices.first.price.length> 2*numberOfDays){

  //    }
    }
  }

  copyDB() async {
    final dbFolder = databaseHelper.path; //await getDatabasesPath();
    File source1 = File(dbFolder);
    //  File('$dbFolder/${databaseHelper.getDatabaseName()}');
    if (kDebugMode) {
      print(" thu muc hien hanh ${source1.path}");
    }
    Directory copyTo = Directory("storage/emulated/0/Download");

    if ((await copyTo.exists())) {
      if (kDebugMode) {
        print("Path exist");
      }
      var status = await Permission.storage.status;
      if (kDebugMode) {
        print("check permission 1 $status");
      }
      if (!status.isGranted) {
        if (kDebugMode) {
          print("check permission");
        }
        await Permission.storage.request();
      }
    } else {
      if (kDebugMode) {
        print("not exist");
      }
      if (await Permission.storage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        await copyTo.create();
      } else {
        if (kDebugMode) {
          print('Please give permission');
        }
      }
    }

    if (kDebugMode) {
      print('chuan bi copy');
    }
    String newPath = "${copyTo.path}/${databaseHelper.getDatabaseName()}";
    if (kDebugMode) {
      print(newPath);
    }
    //await source1.copy(newPath);

    if (kDebugMode) {
      print('Successfully Copied DB');
    }
  }

  deleteDB(StockEventDeleteDB event, Emitter<StockState> emit) async {
    var dbPath = databaseHelper.path;
    try {
      await deleteDatabase(dbPath);
    } catch (e) {
      if (kDebugMode) {
        print('fail to delete DB');
      }
      log(e.toString());
    }
    if (kDebugMode) {
      print('Successfully deleted DB');
    }
  }

  restoreDB(StockEventRestoreDB event, Emitter<StockState> emit) async {
    var dbPath = databaseHelper.path;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.first.path!);
      try {
        file.copy(dbPath);
      } catch (e) {
        if (kDebugMode) {
          print('fail to restore DB');
        }
        log(e.toString());
      }
      if (kDebugMode) {
        print('Successfully restore DB');
      }
    }
  }

  showDetail(StockEventShowDetail event, Emitter<StockState> emit) {
    String stockName = event.stockName.toUpperCase();
    //print(stockName);
    listStockShowDetails = [];
    dataRows = [[], []];
    xUserLabels = [];
    dataRowsLegends = [];
    stockStatus = [];
    double smaPrice;
    int smaValue;
    int smaBuy;
    int smaSell;
    listStockShowDetails = priceMap[stockName] ?? [];
    dataRowsLegends.add(" $stockName's price History");
    dataRowsLegends.add(" $stockName's volume History");
    if (listStockShowDetails.length > 2 * numberOfDays) {
      for (int i = (listStockShowDetails.length - numberOfDays);
          i < listStockShowDetails.length;
          i++) {
        smaPrice = 0;
        smaValue = 0;
        smaBuy = 0;
        smaSell = 0;
        for (int j = (i - numberOfDays); j < i; j++) {
          smaValue += listStockShowDetails[j].valueTotal;
          smaPrice += listStockShowDetails[j].closePrice;
          if (listStockShowDetails[j].priceChangeByPercent > 0) {
            smaBuy += listStockShowDetails[j].valueTotal;
          }

          if (listStockShowDetails[j].priceChangeByPercent < 0) {
            smaSell += listStockShowDetails[j].valueTotal;
          }
        }
        listStockShowDetails[i].smaValue = smaValue / numberOfDays;
        listStockShowDetails[i].smaPrice = smaPrice / numberOfDays;
        if (smaBuy > smaSell) {
          listStockShowDetails[i].status = "1.T";
          listStockShowDetails[i].sell = 0;
          if ((listStockShowDetails[i].valueTotal >
                  2 * listStockShowDetails[i].smaValue!) &&
              listStockShowDetails[i].priceChangeByPercent <= 0) {
            listStockShowDetails[i].status = "2.PP";
          }
        } else {
          listStockShowDetails[i].status = "3.G";
          listStockShowDetails[i].sell = 1;
          if (listStockShowDetails[i].valueTotal >
              1.8 * listStockShowDetails[i].smaValue!) {
            listStockShowDetails[i].status = "4.DC";
          }
        }
        //gia tri mua vuot gia tri ban
        // if (listStockShowDetails[i].closePrice >
        //     listStockShowDetails[i].smaPrice!) {
        //   if ((listStockShowDetails[i].valueTotal *
        //           numberOfDays /
        //           listStockShowDetails[i].smaValue! /
        //           listStockShowDetails[i].smaValue!) >
        //       listStockShowDetails[i].priceChangeByPercent) {
        //     listStockShowDetails[i].status = "Phân phối";
        //   } else {
        //     listStockShowDetails[i].status = " Tăng";
        //   }
        // } else {
        //   if (listStockShowDetails[i].valueTotal >
        //       listStockShowDetails[i].smaValue!) {
        //     listStockShowDetails[i].status = " Đảo chiều";
        //   } else {
        //     listStockShowDetails[i].status = " Giảm";
        //   }
        // }
        stockStatus?.add(listStockShowDetails[i].status!);

        dataRows.first.add(listStockShowDetails[i].normalPrice);
        dataRows.last
            .add(double.parse(listStockShowDetails[i].volumeTotal.toString()));
        xUserLabels
            .add(DateTime.parse(listStockShowDetails[i].date).day.toString());
        if (kDebugMode) {
          print(xUserLabels.toString());
        }
        if (listStockShowDetails[i].status != null) {
          if (kDebugMode) {
            print("${stockStatus.toString()} ");
          }
        }
        if (kDebugMode) {
          print(dataRows.toString());
        }
      }
    }
  }
}
