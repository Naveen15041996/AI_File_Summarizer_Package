public with sharing class FileServiceController {
  @AuraEnabled(cacheable=true)
  public static FileServiceResponse getFiles(Id recordId) {
    try {
      return FileServiceUtility.fetchFiles(recordId);
    } catch (Exception ex) {
      System.debug(
        'Error in FileServiceController.getFiles: ' + ex.getMessage()
      );
      FileServiceResponse response = new FileServiceResponse();
      response.validationMessage = 'An unexpected error occurred while retrieving files. Please contact your administrator.';
      return response;
    }
  }
}
