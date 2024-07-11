import '../Model/stock_model.dart';

class StockState {
  List<StockModel> price;
  List<StockModel> listOrderByVolume;
  List<StockModel> listOrderByMoneyFlow;
  List<StockModel> listOrderBySharpIncrease;
  List<StockBasisModel> listOrderByBasicParameter;
  List<OneDay>? listStockShowDetails;
  List<List<double>> dataRows;
  List<String> xUserLabels;
  List<String> dataRowsLegends;
  List<String>? stockStatus;
  bool showBasicList;
  bool showHighVolumeInPeriod;
  bool showHighValueInDay;
  bool showHighVolumeInDayThanPrevious;
  bool showStockPrice;

  StockState(
      this.listStockShowDetails,

      {
        this.stockStatus,
        required this.price,
      required this.listOrderByVolume,
      required this.listOrderByMoneyFlow,
      required this.listOrderBySharpIncrease,
      required this.listOrderByBasicParameter,
      required this.showHighVolumeInPeriod,
      required this.showHighValueInDay,
      required this.showHighVolumeInDayThanPrevious,
      required this.showBasicList,
        required this.showStockPrice,
        required this.dataRows,
        required this.xUserLabels,
        required this.dataRowsLegends
      });
}

class StockStateLoaded extends StockState {
  StockStateLoaded( super.listStockShowDetails,
      {
        super.stockStatus,
        required super.price,
      required super.listOrderByVolume,
      required super.listOrderByMoneyFlow,
      required super.listOrderBySharpIncrease,
      required super.listOrderByBasicParameter,
      required super.showHighVolumeInPeriod,
      required super.showHighValueInDay,
      required super.showHighVolumeInDayThanPrevious,
      required super.showBasicList,
      required super.showStockPrice,
        required super.dataRows,
        required super.xUserLabels,
        required super.dataRowsLegends});
}

class StockStateLoading extends StockState {
  StockStateLoading(
      super.listStockShowDetails,

      {super.stockStatus,
        required super.price,
      required super.listOrderByVolume,
      required super.listOrderByMoneyFlow,
      required super.listOrderBySharpIncrease,
      required super.listOrderByBasicParameter,
      required super.showHighVolumeInPeriod,
      required super.showHighValueInDay,
      required super.showHighVolumeInDayThanPrevious,
      required super.showBasicList, required super.showStockPrice,
        required super.dataRows,
        required super.xUserLabels,
        required super.dataRowsLegends});
}

