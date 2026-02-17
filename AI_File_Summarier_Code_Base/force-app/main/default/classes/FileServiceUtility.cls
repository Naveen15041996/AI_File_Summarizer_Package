/**
 * @description
 * Utility class responsible for retrieving files linked to a given record
 * after validating AI File Summarizer configuration from Custom Metadata.
 * @author Naveen Rathod
 * @date 17-02-2026
 */
public with sharing class FileServiceUtility {
  private static final Map<String, AI_File_Summarizer_Setting__mdt> fileSummarizerSettingsMap = AI_File_Summarizer_Setting__mdt.getAll();
  private static final String MSG_NOT_CONFIGURED = 'AI File Summarizer feature settings are not configured for this object.';
  private static final String MSG_FEATURE_DISABLED = 'AI File Summarizer feature is not enabled for this object.';

  /**
   * @description Fetches files linked to the provided record Id after validating AI File Summarizer configuration for that object.
   * @param recordId Id of the record from which files need to be retrieved.
   * @return FileServiceResponse
   */
  public static FileServiceResponse fetchFiles(Id recordId) {
    FileServiceResponse response = new FileServiceResponse();

    // Dynamically determine object API name
    String objectName = recordId.getSObjectType().getDescribe().getName();
    // Validate configuration before querying files
    AI_File_Summarizer_Setting__mdt matchedMetadataSetting = validateConfiguration(
      objectName,
      response
    );
    // Stop execution if validation failed
    if (!response.isFeatureEnabled) {
      return response;
    }
    // Fetch files linked to record
    response.files = [
      SELECT
        Id,
        ContentDocumentId,
        ContentDocument.Title,
        ContentDocument.FileType,
        ContentDocument.ContentSize
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :recordId
    ];
    return response;
  }

  /**
   * @description Validates whether AI File Summarizer configuration exists and is enabled for the provided object API name.
   * @param objectName API name of the SObject.
   * @param response FileServiceResponse wrapper used to store validation results.
   * @return AI_File_Summarizer_Setting__mdt Returns matched metadata record if valid. Returns null if validation fails.
   */
  private static AI_File_Summarizer_Setting__mdt validateConfiguration(
    String objectName,
    FileServiceResponse response
  ) {
    AI_File_Summarizer_Setting__mdt matchedMetadataSetting = getMetadataSettingForObject(
      objectName
    );

    if (matchedMetadataSetting == null) {
      response.validationMessage = MSG_NOT_CONFIGURED;
      response.isFeatureEnabled = false;
      return null;
    }

    if (!matchedMetadataSetting.Feature_Enabled__c) {
      response.validationMessage = MSG_FEATURE_DISABLED;
      response.isFeatureEnabled = false;
      return null;
    }

    response.isFeatureEnabled = true;
    return matchedMetadataSetting;
  }

  /**
   * @description Retrieves Custom Metadata configuration record for the specified SObject API name.
   * @param objectName name of the SObject.
   * @return AI_File_Summarizer_Setting__mdt Matching metadata record if found Null if no configuration exists.
   */
  private static AI_File_Summarizer_Setting__mdt getMetadataSettingForObject(
    String objectName
  ) {
    if (String.isBlank(objectName) || fileSummarizerSettingsMap == null) {
      return null;
    }

    for (
      AI_File_Summarizer_Setting__mdt setting : fileSummarizerSettingsMap.values()
    ) {
      if (setting.SObject__c == objectName) {
        return setting;
      }
    }
    return null;
  }
}
