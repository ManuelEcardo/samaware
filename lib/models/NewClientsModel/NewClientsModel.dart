class NewClientsModel
{
  String? clientNumber;
  String? details;
  String? location;
  String? storeName;
  String? salesmanId;


  NewClientsModel({required this.clientNumber, required this.location, this.details, this.salesmanId, this.storeName});

  @override
  String toString() {
    return ''
        '...NewClientsModel'
        'clientNumber: $clientNumber'
        'details: $details'
        'location: $location'
        'storeName: $storeName'
        'salesmanId: $salesmanId'
        '';
  }
}