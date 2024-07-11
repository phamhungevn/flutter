import 'package:elabv01/Common/footer.dart';
import 'package:elabv01/Drawer/drawer.dart';
import 'package:elabv01/StockPage/Blocs/stock_event.dart';
import 'package:elabv01/common/theme.dart';
import 'package:elabv01/common/widgets/button_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:toast/toast.dart';

import 'Blocs/stock_bloc.dart';
import 'Blocs/stock_state.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  static provider() {
    return BlocProvider(
      create: ((context) => StockBloc()..add(StockEventLoadAll())),
      child: const StockPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return BlocConsumer<StockBloc, StockState>(
        builder: (BuildContext context, state) {
      if (kDebugMode) {
        print('do dai ${state.listOrderByMoneyFlow.length}');
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text("Stock Investment"),
          backgroundColor: appTheme.primaryColor,
        ),
        drawer: MyDrawer.provider(),
        bottomNavigationBar: const NavigationBottom(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          //child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonCommon(
                        label: 'Import Price',
                        onTap: () {
                          context.read<StockBloc>().add(StockEventImportFile());
                        },
                        icon: Icons.upload_rounded,
                        color: appTheme.primaryColor,
                        padding: 8,
                      ),
                      ButtonCommon(
                        label: "Stock Analysis",
                        onTap: () {
                          context
                              .read<StockBloc>()
                              .add(StockEventImportBasisFile());
                        },
                        icon: Icons.upload_file,
                        color: appTheme.primaryColor,
                        padding: 8,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonCommon(
                      label: "CopyDB",
                      onTap: () {
                        context.read<StockBloc>().add(StockEventCopyDB());
                      },
                      color: appTheme.primaryColor,
                      padding: 3,
                    ),
                    ButtonCommon(
                      label: "DeleteDB",
                      onTap: () {
                        context.read<StockBloc>().add(StockEventDeleteDB());
                      },
                      color: appTheme.primaryColor,
                      padding: 8,
                    ),
                    ButtonCommon(
                      label: "RestoreDB",
                      onTap: () {
                        context.read<StockBloc>().add(StockEventRestoreDB());
                      },
                      color: appTheme.primaryColor,
                      padding: 3,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Mua lớn nhất trong nhiều ngày"),
                    ButtonCommon(
                        label: 'show',
                        onTap: () {
                          context
                              .read<StockBloc>()
                              .add(StockEventShowHighVolumeInPeriod());
                        },
                        icon: Icons.add,
                        color: appTheme.primaryColor,
                        padding: 8)
                  ],
                ),
                if (state.showHighVolumeInPeriod)
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: constraints.hasBoundedHeight
                                  ? constraints.maxHeight
                                  : 400),
                          child: (state.listOrderByVolume.isNotEmpty)
                              ? CustomScrollView(
                                  slivers: [
                                    SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            (context, index) =>
                                                _MyListItem(index, state),
                                            childCount:
                                                state.listOrderByVolume.length))
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ));
                    },
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Giá trị giao dịch lớn nhất trong ngày"),
                    ButtonCommon(
                        label: 'show',
                        onTap: () {
                          context
                              .read<StockBloc>()
                              .add(StockEventShowHighValueInDay());
                        },
                        icon: Icons.add,
                        color: appTheme.primaryColor,
                        padding: 8)
                  ],
                ),
                if (state.showHighValueInDay)
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: (state.listOrderByMoneyFlow.isNotEmpty)
                          ? CustomScrollView(
                              slivers: [
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (context, index) =>
                                            _MyListItemMoneyFlow(index, state),
                                        childCount:
                                            state.listOrderByMoneyFlow.length))
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Giá trị giao dịch đột biến trong ngày"),
                    ButtonCommon(
                        label: 'show',
                        onTap: () {
                          //  showHighVolumeInDayThanPrevious = !showHighVolumeInDayThanPrevious;
                          context
                              .read<StockBloc>()
                              .add(StockEventShowHighVolumeInDayThanPrevious());
                        },
                        icon: Icons.add,
                        color: appTheme.primaryColor,
                        padding: 8)
                  ],
                ),
                if (state.showHighVolumeInDayThanPrevious)
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: (state.listOrderBySharpIncrease.isNotEmpty)
                          ? CustomScrollView(
                              slivers: [
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (context, index) =>
                                            _MyListItemSharpIncrease(
                                                index, state),
                                        childCount: state
                                            .listOrderBySharpIncrease.length))
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Giá trị cơ bản"),
                    ButtonCommon(
                        label: 'show',
                        onTap: () {
                          context
                              .read<StockBloc>()
                              .add(StockEventShowBasicList());
                        },
                        icon: Icons.add,
                        color: appTheme.primaryColor,
                        padding: 8)
                  ],
                ),
                if (state.showBasicList)
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: (state.listOrderByBasicParameter.isNotEmpty)
                          ? CustomScrollView(
                              slivers: [
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (context, index) =>
                                            _MyListItemBasicParameter(
                                                index, state),
                                        childCount: state
                                            .listOrderByBasicParameter.length))
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Stock Prices"),
                    ButtonCommon(
                        label: 'show',
                        onTap: () {
                          context
                              .read<StockBloc>()
                              .add(StockEventShowStockPrice());
                        },
                        icon: Icons.add,
                        color: appTheme.primaryColor,
                        padding: 8)
                  ],
                ),
                if (state.showStockPrice)
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: (state.price.isNotEmpty)
                          ? CustomScrollView(
                              slivers: [
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (context, index) =>
                                            _MyListItemStockPrice(index, state),
                                        childCount: state.price.length))
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          hintText: "Stock Name",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    ButtonCommon(
                        label: 'Search',
                        onTap: () {
                          context.read<StockBloc>().add(StockEventShowDetail(
                              stockName: textEditingController.text));
                        },
                        icon: Icons.add,
                        color: appTheme.primaryColor,
                        padding: 8)
                  ],
                ),
                if (state.dataRowsLegends.isNotEmpty)
                  SizedBox(
                      height: 500,
                      width: 300,
                      child: ChartToRunVolume(
                        state: state,
                      )),
                if (state.dataRowsLegends.isNotEmpty)
                  SizedBox(
                      height: 500,
                      width: 300,
                      child: ChartToRunPrice(
                        state: state,
                      )),
                if (state.listStockShowDetails != null)
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                      _MyListPriceHistory(index, state),
                                  childCount:
                                      state.listStockShowDetails!.length))
                        ],
                      ))
              ],
            ),
          ),
          // ),
        ),
      );
    }, listener: (BuildContext context, StockState state) {
      if (state is StockStateLoading) {
        ToastContext().init(context);
        Toast.show("Loading");
      }
      if (state is StockStateLoaded) {
        ToastContext().init(context);
        Toast.show("Successfully");
      }
    });
  }
}

class _MyListItemStockPrice extends StatelessWidget {
  final int index;
  final StockState state;

  const _MyListItemStockPrice(this.index, this.state);

  @override
  Widget build(BuildContext context) {
    var item = state.price.elementAt(index);
    return LimitedBox(
      maxHeight: 70,
      child: Column(
        children: [
          Row(
            children: [
              Text(index.toString()),
              const SizedBox(
                width: 10,
              ),
              Text(item.name),
              Flexible(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child:
                          Text('Normal Price: ${item.price.last.normalPrice}')))
            ],
          ),
          Row(
            children: [
              Text('first date: ${item.price.first.date}'),
            ],
          ),
          Row(
            children: [
              Text('last date: ${item.price.last.date}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyListItemBasicParameter extends StatelessWidget {
  final int index;
  final StockState state;

  const _MyListItemBasicParameter(this.index, this.state);

  @override
  Widget build(BuildContext context) {
    var item = state.listOrderByBasicParameter.elementAt(index);
    return LimitedBox(
      maxHeight: 70,
      child: Column(
        children: [
          Row(
            children: [
              Text(index.toString()),
              const SizedBox(
                width: 10,
              ),
              Text(item.name),
              Flexible(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                          'Real Price: ${item.parameters.last.realPrice?.toStringAsFixed(2)}')))
            ],
          ),
          Row(
            children: [
              Text(
                  'ProfitEfficiency: ${item.parameters.last.profitEfficiency?.toStringAsFixed(2)}'),
              const SizedBox(width: 10),
              Text(
                  'managementEfficiency: ${item.parameters.last.managementEfficiency?.toStringAsFixed(2)}')
            ],
          ),
          Row(
            children: [Text(item.parameters.last.date)],
          )
        ],
      ),
    );
  }
}

class _MyListItemSharpIncrease extends StatelessWidget {
  final int index;
  final StockState state;

  const _MyListItemSharpIncrease(this.index, this.state);

  @override
  Widget build(BuildContext context) {
    var item = state.listOrderBySharpIncrease.elementAt(index);
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 5),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.blueGrey),
            color: Colors.grey),
        child: LimitedBox(
          maxHeight: 70,
          child: Column(
            children: [
              Row(
                children: [
                  Text(index.toString()),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40)),
                          border: Border.all(color: Colors.blueGrey),
                          color: appTheme.primaryColor),
                      child: InkWell(
                        child: Text(item.name),
                        onTap: () {
                          if (kDebugMode) {
                            print("da bam detail");
                          }
                          context
                              .read<StockBloc>()
                              .add(StockEventShowDetail(stockName: item.name));
                        },
                      )),
                  Flexible(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              'Total Value: ${item.price.last.valueTotal}')))
                ],
              ),
              Row(
                children: [Text(item.price.last.date)],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MyListItemMoneyFlow extends StatelessWidget {
  final int index;
  final StockState state;

  const _MyListItemMoneyFlow(this.index, this.state);

  @override
  Widget build(BuildContext context) {
    var item = state.listOrderByMoneyFlow.elementAt(index);
    return LimitedBox(
      maxHeight: 70,
      child: Column(
        children: [
          Row(
            children: [
              Text(index.toString()),
              const SizedBox(
                width: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      border: Border.all(color: Colors.blueGrey),
                      color: appTheme.primaryColor),
                  child: InkWell(
                    child: Text(item.name),
                    onTap: () {
                      if (kDebugMode) {
                        print("da bam detail");
                      }
                      context
                          .read<StockBloc>()
                          .add(StockEventShowDetail(stockName: item.name));
                    },
                  )),
              Flexible(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child:
                          Text('Total Value: ${item.price.last.valueTotal}')))
            ],
          ),
          Row(
            children: [Text(item.price.last.date)],
          )
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;
  final StockState state;

  const _MyListItem(this.index, this.state);

  @override
  Widget build(BuildContext context) {
    var item = state.listOrderByVolume.elementAt(index);
    if (kDebugMode) {
      print(item.name);
    }
    return LimitedBox(
        maxHeight: 75,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(index.toString()),
                const SizedBox(
                  width: 10,
                ),
                Text(item.name),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                        'Volume buy: ${item.price.last.totalVolumeBuy.toString()})'),
                  ),
                )
              ],
            ),
            Row(children: [
              Text('date ${item.price.last.date}'),
            ])
          ],
        ));
  }
}

class ChartToRunVolume extends StatelessWidget {
  final StockState state;

  const ChartToRunVolume({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();

    chartData = ChartData(
        dataRows: [state.dataRows.last],
        xUserLabels: state.xUserLabels,
        dataRowsLegends: [state.dataRowsLegends.last],
        chartOptions: chartOptions,
        dataRowsColors: const [Colors.green]);
    // chartData = RandomChartData.generated(chartOptions: chartOptions);
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }
}

class ChartToRunPrice extends StatelessWidget {
  final StockState state;

  const ChartToRunPrice({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();

    chartData = ChartData(
        dataRows: [state.dataRows.first],
        xUserLabels: state.stockStatus!,
        dataRowsLegends: [state.dataRowsLegends.first],
        chartOptions: chartOptions,
        dataRowsColors: const [Colors.green]);
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }
}

class _MyListPriceHistory extends StatelessWidget {
  final int index;
  final StockState state;

  const _MyListPriceHistory(this.index, this.state);

  @override
  Widget build(BuildContext context) {
    var item = state.listStockShowDetails!.elementAt(index);
    // if (kDebugMode) {
    //
    // }
    return LimitedBox(
        maxHeight: 35,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(item.date.toString()),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('Price: ${item.normalPrice.toString()}'),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
