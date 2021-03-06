import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pmreport/blocs/blocs.dart';
import 'package:pmreport/blocs/itemdatas/itemdatas.dart';
import 'package:pmreport/blocs/items/items_bloc.dart';
import 'package:pmreport/blocs/parts/parts.dart';
import 'package:pmreport/blocs/topics/topics_bloc.dart';
import 'package:pmreport/ui/home/widgets/loading_indicator.dart';
import 'package:pmreport/ui/topic/widgets/dataitem_widget.dart';
import 'package:pmreport/utils/dialog_widget.dart';
import 'package:pmreport/utils/sizes_helpers.dart';
import 'package:preventive_maintenance_repository/preventive_maintenance_repository.dart';
import 'package:preventive_maintenance_repository/src/models/item.dart';

class ItemsMenu extends StatefulWidget {
  String categoryUid;
  String partUid;
  String topicUid;
  Topic topic;
  ItemDatasBloc itemDatasBloc;
  ItemsMenu({Key key, this.categoryUid, this.partUid, this.topicUid, this.topic, this.itemDatasBloc}) : super(key: key);

  @override
  _ItemsMenuState createState() => _ItemsMenuState(
      categoryUid: this.categoryUid,
      partUid: this.partUid,
      topicUid: this.topicUid,
      topic: this.topic,
      itemDatasBloc: this.itemDatasBloc
  );
}

class _ItemsMenuState extends State<ItemsMenu> {
  String categoryUid;
  String partUid;
  String topicUid;
  Topic topic;
  ItemDatasBloc itemDatasBloc;
  _ItemsMenuState({
    String categoryUid,
    String partUid,
    String topicUid,
    Topic topic,
    ItemDatasBloc itemDatasBloc}) :
        this.categoryUid = categoryUid,
        this.partUid = partUid,
        this.topicUid = topicUid,
        this.topic = topic,
        this.itemDatasBloc = itemDatasBloc;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsBloc, ItemsState>(
        builder: (context, state) {

          if(state is ItemsLoading) {
            return LoadingIndicator();
          } else if(state is ItemsNotLoaded) {
            return Container(
              child: Text('Data not found'),
            );
          } else if(state is ItemsLoaded) {
            print('++++++ ItemsLoaded ++++++');
            final items = state.items;
            print('items.length[${items.length}]');
            if(items.length > 0) {
              int currentSwiperIndex = 0;
              return Container(
                height: displayHeight(context) * 0.6,
                width: displayWidth(context),
                color: Colors.lightGreen[50],
                child: Swiper(
                  onIndexChanged: (index)  {
                    currentSwiperIndex = index;
                    print('current swiper index[${index}] currentSwiperIndex[${currentSwiperIndex}]');
                  },
                  itemBuilder: (BuildContext context, int index) {
                    // final item = (items.length == 0) ? templateItems[index] : items[index];
                    final item = items[index];

                    print('**Caller index[${index}] - item.index[${item.index}] - item.uid[${item.uid}]');
                    // Get itemdata list stream
                    // context.bloc<ItemDatasBloc>().add(LoadItemDatas(categoryUid, partUid, topicUid, topic, item));

                    item.topic = topic;
                    return Column(

                      children: [
                        // Image.asset(
                        //   'assets/${categoryUid}_h96.png',
                        //   fit: BoxFit.fitHeight,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0,),

                          child: Container(
                            height: displayHeight(context) * 0.5,
                            width: displayWidth(context),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.amber[600],
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.brown[400],
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [Colors.brown[400], Colors.brown[50]]
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                buildDataArea(context, item),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  autoplay: false,
                  // itemCount: (items.length == 0) ? templateItems.length : items.length,
                  itemCount: items.length,
                  itemWidth: 300.0,
                  itemHeight: 400.0,
                  layout: SwiperLayout.TINDER,
                  pagination: new SwiperPagination(
                      margin: new EdgeInsets.all(0.0),
                      builder: new SwiperCustomPagination(builder:
                          (BuildContext context, SwiperPluginConfig config) {
                        return DotSwiperPaginationBuilder(
                            color: Colors.black12,
                            activeColor: Colors.brown,
                            size: 5.0,
                            activeSize: 10.0
                        ).build(context, config);
                      }
                      )
                  ),
                  control: new SwiperControl(color: Colors.redAccent),
                ),
              );
            } else {
              return AlertDialog(
                title: new Text("Message - [${topic.platform}]"),
                content: new Text("Item data not found."),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(false);
                    },
                  ),
                ],
              );

            }
          }
        },
      // ),
    );
  }

  List<Widget> buildDataArea(BuildContext context, Item item) {
    List<Widget> widgets = new List();

    // item index + item name
    widgets.add(Text(
      "${item.index}. ${item.name}",
      style: TextStyle(fontSize: 20.0, color: Colors.brown),
    )
    );
    for(int i=2;i<item.headers.length;i++){
      // call a ItemData load stream
      // context.bloc<ItemDatasBloc>().add(LoadItemData(categoryUid, partUid, topicUid, topic, item, item.headers[i].uid));
      switch(i % 2) {
        case 0: { // left
          print('left[${i}] ${item.headers[i].uid}');
          Widget leftWidget = buildDataItem(context, item, i);
          widgets.add(leftWidget);
        }
        break;
        case 1: { // right
          print('right[${i}] ${item.headers[i].uid}');
          Widget rightWidget = buildDataItem(context, item, i);
          widgets.add(rightWidget);
        }
        break;

        default:
        break;

      }
    }

    return widgets;
  }

  ItemData getItemData(Header header, Item item) {
    ItemData dataValue = ItemData(
        id: header.uid,
        uid: header.uid,
        index: header.index,
        name: header.name,
        inputType: header.inputType
    );
    for(int i=0; i<item.itemDatas.length;i++) {
      if(item.itemDatas[i].uid == header.uid) {
        dataValue.value = item.itemDatas[i].value;
        return dataValue;
      }
    }
    return dataValue;
  }

  Widget buildDataItem(BuildContext context, Item item, int i) {
    ItemData itemData = getItemData(item.headers[i], item);
    print('<<<header[${item.headers[i].uid} -> From Item Bloc list${itemData}>>> item no.${item.index} [${item.uid}] ');

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: DataItemWidget(
        categoryUid: categoryUid,
        partUid: partUid,
        topicUid: topicUid,
        topic: topic,
        item: item,
        header: item.headers[i],
        itemDatasBloc: itemDatasBloc,
      ),
    );
  }

  ItemData getItemDataByUid(String itemUid, String itemDataUid, List<ItemData> itemDatas) {
    ItemData result = ItemData(uid: itemDataUid, value: '');
    print('getItemDataByUid=======uid${itemDataUid}');
    for(int i=0; i< itemDatas.length;i++) {
      print('${itemUid} <==> ${itemDatas[i].itemUid}');
      print('itemDataUid[${itemDataUid}] <--->itemDatas[i].uid[${itemDatas[i].uid}]');
      if(itemDataUid == itemDatas[i].uid && itemUid == itemDatas[i].itemUid) {
        print('match!!!!!');
        return itemDatas[i];
      }
    }
    return result;
  }
}
