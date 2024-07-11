import '../Model/stock_model.dart';

abstract class StockEvent{}
class StockEventAdd extends StockEvent{
  List<StockModel> price;
  StockEventAdd({required this.price});
}
class StockEventLoadAll extends StockEvent{

}
class StockEventImportFile extends StockEvent{}
class StockEventImportBasisFile extends StockEvent{}
class StockEventShowHighVolumeInPeriod extends StockEvent{}
class StockEventShowBasicList extends StockEvent{}
class StockEventShowHighValueInDay extends StockEvent{}
class StockEventShowHighVolumeInDayThanPrevious extends StockEvent{}
class StockEventShowStockPrice extends StockEvent{}
class StockEventCopyDB extends StockEvent{}
class StockEventDeleteDB extends StockEvent{}
class StockEventRestoreDB extends StockEvent{}
class StockEventShowDetail extends StockEvent{
  String stockName;
  StockEventShowDetail({required this.stockName});
}