class NewClientsModel
{
  String? clientNumber;
  String? clientName;
  String? details;
  String? location;
  String? storeName;
  String? salesmanId;


  NewClientsModel({required this.clientNumber, required this.clientName, required this.location, this.details, this.salesmanId, this.storeName});


  void set(String clientNumber, String clientName, String details, String location, String storeName, String salesmanId)
  {
    this.clientName=clientName;
    this.clientNumber = clientNumber;

    this.details=details;
    this.location=location;

    this.storeName=storeName;
    this.salesmanId=salesmanId;
  }

  @override
  String toString() {
    return ''
        '...NewClientsModel\n'
        'clientNumber: $clientNumber\n'
        'clientName: $clientName\n'
        'details: $details\n'
        'location: $location\n'
        'storeName: $storeName\n'
        'salesmanId: $salesmanId\n'
        '';
  }
}