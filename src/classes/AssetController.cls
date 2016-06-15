global with sharing class AssetController {

    public AssetController() { } // empty constructor

    public AssetController(ApexPages.StandardController controller) {
        Asset myasset = (Asset)controller.getRecord();
    }
    
    @RemoteAction
    global static void insertTemperatureRecord(Integer temperature, Id assetId) {
        Device_Data__c deviceData = new Device_Data__c();
        
        deviceData.Device_Temperature_in_C__c = temperature;
        deviceData.Asset_Device__c = assetId;
       
        Insert deviceData;        
    }
}