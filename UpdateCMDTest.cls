@isTest
public class UpdateCMDTest {
    @IsTest
    public static void configSetupTest(){
        String fullName   = 'Email_To_Lead__mdt.Email_To_Lead_Config';
        String label      = 'Email To Lead Config';
        String values = '{' + 
                        ' "Lead_Source__c": "Email",' + 
                        ' "Lead_Status__c": "NEW",' + 
                        ' "Record_Type_Name__c":"Email_To_Lead",' + 
                        ' "Task_Subject__c" : "Test"' + '}';
        Map < String, Object > deployedValue = (Map < String, Object > ) JSON.deserializeUntyped(values);

        Test.startTest();
        UpdateCMD.createCustomMetadata(fullName, label, deployedValue);
        Test.stopTest();
    }
    
    @IsTest
    public static void configSetupTestUpdate(){
        String fullName   = 'Email_To_Lead__mdt';
        String label      = 'Email To Lead Config';
        String devName = 'Email_To_Lead_Config';
        String values = '{' + 
                        ' "Lead_Source__c": "Email",' + 
                        ' "Lead_Status__c": "NEW",' + 
                        ' "Record_Type_Name__c":"Email_To_Lead",' + 
                        ' "Task_Subject__c" : "Test"' + '}';
        Map < String, Object > deployedValue = (Map < String, Object > ) JSON.deserializeUntyped(values);
        
        Test.startTest();
        UpdateCMD.updateCustomMetadata(fullName, devName, label, deployedValue);
        Test.stopTest();
    }

    @IsTest
    public static void UpdateMetadataUtilsTest(){

        // Mock input data
        UpdateCMD.ActionRequest request = new UpdateCMD.ActionRequest();
        
        sObject sObj = Schema.getGlobalDescribe().get('Email_To_Lead__mdt').newSObject();
        sObj.put('DeveloperName', 'Email_To_Lead_Config');
        sObj.put('Label', 'Email_To_Lead_Config');
        sObj.put('Task_Subject__c','Test');
        
        request.data = new List<sObject>{sObj};
    
        Test.startTest();
            UpdateCMD.invokeService(new List<UpdateCMD.ActionRequest>{request});
        Test.stopTest();
    }
    
    @IsTest
    public static void CreateMetadataUtilsTest(){

        // Mock input data
        UpdateCMD.ActionRequest request = new UpdateCMD.ActionRequest();
        
        sObject sObj = Schema.getGlobalDescribe().get('Email_To_Lead__mdt').newSObject();
        //sObj.put('DeveloperName', 'Email_To_Lead_Config');
        sObj.put('Label', 'Email_To_Lead_Config');
        sObj.put('Task_Subject__c','Test');
        
        request.data = new List<sObject>{sObj};
    
        Test.startTest();
            UpdateCMD.invokeService(new List<UpdateCMD.ActionRequest>{request});
        Test.stopTest();
    }
    
    @IsTest
    public static void CustomExceptionTest(){

        // Mock input data
        UpdateCMD.ActionRequest request = new UpdateCMD.ActionRequest();
        
        sObject sObj = Schema.getGlobalDescribe().get('Email_To_Lead__mdt').newSObject();
        //sObj.put('DeveloperName', 'Email_To_Lead_Config');
        //sObj.put('Label', 'Email_To_Lead_Config');
        sObj.put('Task_Subject__c','Test');
        
        request.data = new List<sObject>{sObj};
    	Exception unexpectedException;
 
        Test.startTest();
        try{
            UpdateCMD.invokeService(new List<UpdateCMD.ActionRequest>{request});
        } catch (Exception ex){
            unexpectedException = ex;
            system.assertEquals('Make sure to add "Label" attribute in assignemnt for Create and "DeveloperName" for update.', ex.getMessage(), 'Exceptions should be handled by the method');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testHandleResult() {
        // Instantiate the UpdateCMD class
        UpdateCMD callback = new UpdateCMD();
        
        // Mock Metadata.DeployResult for success
        Metadata.DeployResult successResult = new Metadata.DeployResult();
        successResult.status = Metadata.DeployStatus.Succeeded;
        
        // Mock Metadata.DeployCallbackContext
        Metadata.DeployCallbackContext context = new Metadata.DeployCallbackContext();
        
        // Test success scenario
        Test.startTest();
        callback.handleResult(successResult, context);
        Test.stopTest();
        
        /*// Assert success (no exception should be thrown)
        System.assertEquals(Metadata.DeployStatus.Succeeded, successResult.status);
        
        // Mock Metadata.DeployResult for failure
        Metadata.DeployResult failureResult = new Metadata.DeployResult();
        failureResult.status = Metadata.DeployStatus.Failed;
        
        // Test failure scenario
        Test.startTest();
        try {
            callback.handleResult(failureResult, context);
            System.assert(false, 'Expected exception was not thrown.');
        } catch (UpdateCMD.CustomException ex) {
            System.assertEquals(String.valueOf(failureResult), ex.getMessage());
        }
        Test.stopTest();*/
    }
    
    
   
}
