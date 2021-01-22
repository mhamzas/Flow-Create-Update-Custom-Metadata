/**
 * @description       : This invocable class will allow you to update/create customMetadata using Flow/Process Builder.
 * @author            : M Hamza Siddiqui @ mhamzas.com
 * @group             : Cloudjunction Advisors, Inc.
 * @last modified on  : 01-21-2021
 * @last modified by  : M Hamza Siddiqui @ mhamzas.com
 * Modifications Log 
 * -----------------
 * Ver   Date         Author                             		Modification
 * 1.0   01-22-2021   M Hamza Siddiqui @ mhamzas.com		   Initial Version
**/
global class UpdateCMD implements Metadata.DeployCallback {

    /*An invocable variable used as input or output variables in the process builder*/
    global class ActionRequest {
        @InvocableVariable(required = true)
        public List<sObject> data;
    }
    //This invocable method is used for processing the business by taking the input from process builder/flow
    @InvocableMethod(label = 'Create/Update Custom Metadata')
        global static void invokeService(List <ActionRequest> requests) {
          for (ActionRequest requestObj: requests) {
              //Accessing the values from process builder/flow when record is inserted
              for(sObject obj : requestObj.data){
                  //System.debug('requestObj.sObject@@:' + obj);
                  //System.debug('requestObj.ObjectType@@:' + obj.getSObjectType());
                  // Getting all the Populated fields in a Map
                  Map<String, Object> fieldsToValue = obj.getPopulatedFieldsAsMap();
                  Map<String, Object> metadataFieldValueMap = new Map<String, Object>();
                  String MetadataDevName; // To Store Custom Metadata Record API/Developer name
                  String MetadataLabel; // To Store Custom Metadata Label name
                  // Looping on all the populated fields
                  for (String fieldName : fieldsToValue.keySet()){
                      System.debug('field name is ' + fieldName + ', value is ' + fieldsToValue.get(fieldName));
                      // We don't want to add system fields to the Map for update, so here is some simple logic
                      if(fieldName == 'Label'){
                          MetadataLabel = (String)fieldsToValue.get(fieldName);
                      } else if(fieldName == 'DeveloperName'){
                          MetadataDevName = (String)fieldsToValue.get(fieldName);
                      } else if(fieldName != 'Id' && fieldName != 'Language' && fieldName != 'MasterLabel' && fieldName != 'NamespacePrefix' && fieldName != 'QualifiedApiName') {
                          // Populating Map for Processing later
                          metadataFieldValueMap.put(fieldName, fieldsToValue.get(fieldName));
                      }
                  }
                  
                  System.debug('Label is ' + MetadataLabel + '& DeveloperName is ' + MetadataDevName);
                  // Making sure to have either Label or Developer Name for the CMD record to process
                  if(String.isBlank(MetadataDevName) && String.isBlank(MetadataLabel)){
                      throw createCustomException('Make sure to add "Label" attribute in assignemnt for Create and "DeveloperName" for update.');
                  } else { 
                      //if MetadataDevName available, which means the record exists already - Processing UPDATE
                      if(!String.isBlank(MetadataDevName)){
                          UpdateCMD.updateCustomMetadata(String.valueof(obj.getSObjectType()),MetadataDevName, MetadataLabel,metadataFieldValueMap);
                      } else { // Creating a new Custom Metadata record
                          //if ID not available - CREATE
                          UpdateCMD.createCustomMetadata(String.valueof(obj.getSObjectType()), MetadataLabel, metadataFieldValueMap);
                      }
                  }
                  // END
              }
          }
    }
    
    /* Custom Metadata Deploy Methods */
    /* ============================================================*/
    //Inteface method 
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            //Success
            System.debug('Success Result-' + result);
        } else {
            //Failed
            System.debug('Failed Result-' + result);
            throw createCustomException(String.valueof(result));
        }
    }
     
    //Create Custom Metadata record
    public static void createCustomMetadata(String metdataName, String label, Map<String, Object> metadataFieldValueMap){
        String recordDevName = label.replaceAll(' ', '_');
        Metadata.CustomMetadata cMetadata = new Metadata.CustomMetadata();
        cMetadata.fullName = metdataName + '.' + recordDevName;
        cMetadata.label = label;
         
        for(String key : metadataFieldValueMap.keySet()){
            Metadata.CustomMetadataValue cMetadataValue = new Metadata.CustomMetadataValue();
            cMetadataValue.Field = key;
            cMetadataValue.Value = metadataFieldValueMap.get(key); 
            cMetadata.values.add(cMetadataValue);
        }
         
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(cMetadata);
        UpdateCMD callback = new UpdateCMD();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
     
    //Update Custom Metadata record
    public static void updateCustomMetadata(String metdataName, String recordDevName, String label, Map<String, Object> metadataFieldValueMap){
        Metadata.CustomMetadata cMetadata = new Metadata.CustomMetadata();
        cMetadata.fullName = metdataName + '.' + recordDevName;
        cMetadata.label = label;
         
        for(String key : metadataFieldValueMap.keySet()){
            Metadata.CustomMetadataValue cMetadataValue = new Metadata.CustomMetadataValue();
            cMetadataValue.Field = key;
            cMetadataValue.Value = metadataFieldValueMap.get(key); 
            cMetadata.values.add(cMetadataValue);
        }
         
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(cMetadata);
        UpdateCMD callback = new UpdateCMD();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }

    /* Flow Exception Handling */
    /* ============================================================*/
    public class CustomException extends Exception {}
    
    static CustomException createCustomException(String message) {
        CustomException ex = new CustomException(message);
        ex.setMessage(message);
        return ex;
    }
}
