class SubmitOrderModel
{
  String? orderId;
  String? workerId;
  String? clientId;

  String? registrationDate;
  String? shippingDate;



  List<OrderItem>? items=[];

  void setId(String o)
  {
    orderId=o;
  }

  void setRegistrationDate(String date)
  {
    registrationDate=date;
  }

  void setShippingDate(String date)
  {
    shippingDate=date;
  }

  void addItem(OrderItem item)
  {
    items?.add(item);
  }

  SubmitOrderModel();

  //Creating an Order
  SubmitOrderModel.create({required String id, required String regDate, required String shipDate, String? worker, String? client, List<OrderItem>? itemList})
  {
    orderId=id;
    registrationDate=regDate;
    shippingDate=shipDate;

    workerId=worker;
    clientId=client;

    itemList?.forEach((item)
    {
      items?.add(item);
    });
  }


  @override
  String toString() {
    // TODO: implement toString
    return "orderId:$orderId, registrationDate: $registrationDate, shippingDate: $shippingDate, workerId:$workerId, clientId: $clientId, items: ${items.toString()} ";
  }
}


class OrderItem
{
  String? itemId;
  double? quantity;
  String? type;
  String? name;

  OrderItem({required this.itemId, required this.quantity, required this.type, required this.name});

  void setQuantity(double q)
  {
    quantity=q;
  }

  void setType(String t)
  {
    type=t;
  }

  OrderItem.fromJson(Map<String,dynamic> json)
  {
    itemId=json['itemId'];
    quantity= double.tryParse(json['quantity'].toString());
    type=json['type'];
    name=json['name'];
  }

  @override
  String toString() {
    return 'itemId: $itemId, quantity: $quantity, type: $type, name: $name';
  }
}