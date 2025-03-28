//=============================================================================
// SetupProduct: Information about an installable product.
//=============================================================================
class SetupProduct extends SetupObject
	native
	perobjectconfig;

// Per product information.
var config string Product;
var config string Version;

// Per product, per-language information.
var localized string LocalProduct, Developer;
var localized string ProductURL, VersionURL, DeveloperURL;

defaultproperties
{
     Product=Product
     Version=100
     LocalProduct=Product
     Developer=Developer
     ProductURL=http
     VersionURL=http
     DeveloperURL=http
}
