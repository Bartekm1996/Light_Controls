class Asset{

  final String name;
  final String vendorName;
  final String productName;
  final String productId;
  final String status;
  final String statusInfo;
  final String statusDescription;

  Asset(this.name, this.vendorName, this.productName, this.productId, this.status, this.statusInfo, {this.statusDescription});
}