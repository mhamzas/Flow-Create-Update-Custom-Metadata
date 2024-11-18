@isTest
public class UpdateCMDTest {
    
    @isTest
    static void testCreateAndUpdateCustomMetadata() {
        // Create test data
        CustomMetadata__mdt cmdRecord = new CustomMetadata__mdt(
            MasterLabel = 'Test Label',
            DeveloperName = 'Test_Dev_Name'
        );
        insert cmdRecord;

        // Prepare mock data for flow requests
        UpdateCMD.ActionRequest request = new UpdateCMD.ActionRequest();
        List<sObject> sObjects = new List<sObject>();

        // Test create scenario (with no DeveloperName)
        CustomMetadata__mdt createCmd = new CustomMetadata__mdt(
            MasterLabel = 'New Label'
        );
        sObjects.add(createCmd);

        // Test update scenario (with DeveloperName)
        CustomMetadata__mdt updateCmd = new CustomMetadata__mdt(
            MasterLabel = 'Updated Label',
            DeveloperName = 'Test_Dev_Name'
        );
        sObjects.add(updateCmd);

        request.data = sObjects;

        // Invoke the service
        Test.startTest();
        UpdateCMD.invokeService(new List<UpdateCMD.ActionRequest>{request});
        Test.stopTest();
        
        // Assertions to validate behavior
        CustomMetadata__mdt updatedCmd = [SELECT MasterLabel FROM CustomMetadata__mdt WHERE DeveloperName = 'Test_Dev_Name' LIMIT 1];
        System.assertEquals('Updated Label', updatedCmd.MasterLabel);
        
        // Check if new record was created
        CustomMetadata__mdt newCmd = [SELECT MasterLabel FROM CustomMetadata__mdt WHERE MasterLabel = 'New Label' LIMIT 1];
        System.assertEquals('New Label', newCmd.MasterLabel);
    }
}
