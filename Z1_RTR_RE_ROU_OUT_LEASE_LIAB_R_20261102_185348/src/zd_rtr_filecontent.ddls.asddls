/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 12.02.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK911054
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
/////////////////////////////////////////////////////////////////////////

@EndUserText.label: 'File Content'
define abstract entity ZD_RTR_FileContent
{
//  @Semantics.largeObject: {
//    mimeType  : 'MimeType',
//    fileName  : 'FileName',
//    contentDispositionPreference: #INLINE
//  }
  FileContent : ze_filecontent;

  @Semantics.mimeType: true
  MimeType    : ze_mimetype;

  FileName    : ze_filename;
}
