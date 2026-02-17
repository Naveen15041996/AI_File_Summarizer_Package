/**
 * @description Wrapper response class used to return AI File Summarizer execution results to LWC.
 */
public class FileServiceResponse {
  @AuraEnabled
  public Boolean isFeatureEnabled;

  @AuraEnabled
  public String validationMessage;

  @AuraEnabled
  public List<ContentDocumentLink> files;

  /**
   * Default constructor
   * Initializes safe default values.
   */
  public FileServiceResponse() {
    this.isFeatureEnabled = false;
    this.validationMessage = null;
    this.files = new List<ContentDocumentLink>();
  }
}
