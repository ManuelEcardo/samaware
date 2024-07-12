class OrderModel
{
  String? orderId;
  String? registrationDate;

  String? shippingDate;
  String? workerId;

  String? clientId;
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

  OrderModel();

  //Creating an Order
  OrderModel.create({required String id, required String regDate, required String shipDate, String? worker, String? client, List<OrderItem>? itemList})
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
    this.quantity=q;
  }

  void setType(String t)
  {
    this.type=t;
  }
}