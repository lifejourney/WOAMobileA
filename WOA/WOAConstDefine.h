//
//  WOAConstDefine.h
//  WOAMobileA
//
//  Created by Steven (Shuliang) Zhuang on 9/17/16.
//  Copyright © 2016 steven.zhuang. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kWOAKeyForPinyinInitial @"_pinyin"
#define kWOAKeyForMainValue @"_mainValue"
#define kWOAKeyForSubValue @"_subValue"
#define KWOAKeyForActionTitle @"_actionTitle"

#define kWOASrvKeyForWorkID @"workID"
#define kWOASrvKeyForItemArrays @"items"
#define kWOASrvKeyForDataFieldArrays @"dataFields"
#define kWOASrvKeyForItemID @"itemID"
#define kWOASrvKeyForItemName @"name"
#define kWOASrvKeyForItemType @"type"
#define kWOASrvKeyForItemValue @"value"
#define kWOASrvKeyForItemOptionArray @"combo"
#define kWOASrvKeyForItemAccountID @"account"
#define kWOASrvKeyForItemWritable @"isWrite"
#define kWOASrvKeyForItemReadonly @"readonly"

#define kWOASrvKeyForAccountArray @"account"
#define kWOASrvKeyForAccountID @"account"
#define kWOASrvKeyForAccountName @"name"

#define kWOASrvKeyForTableStruct @"tableStruct"
#define kWOASrvKeyForTableID @"tableID"
#define kWOASrvKeyForTableName @"tableName"

#define kWOASrvKeyForTableOwnTableArray @"selfItems"
#define kWOASrvKeyForTableOthersTableArray @"otherItems"
#define kWOASrvKeyForTableStyle @"tableStyle"
#define kWOASrvValueForOwnTableType @"selfItem"
#define kWOAValueForOwnTableTypeTitle @"我的教学业务表"
#define kWOASrvValueForOthersTableType @"otherItem"
#define kWOAValueForOthersTableTypeTitle @"其他教学业务表"

#define kWOASrvKeyForTermArray @"termItems"
#define kWOASrvKeyForTermName @"termItem"
#define kWOASrvKeyForGradeArray @"gradeItems"
#define kWOASrvKeyForGradeID_Get @"id"
#define kWOASrvKeyForGradeID_Post @"gradeID"
#define kWOASrvKeyForGradeName @"name"
#define kWOASrvKeyForClassArray @"classItems"
#define kWOASrvKeyForClassID_Get @"id"
#define kWOASrvKeyForClassID_Post @"classID"
#define kWOASrvKeyForClassName @"name"

#define kWOASrvKeyForSubjectGradeName @"gradeName"
#define kWOASrvKeyForSubjectTermName @"yearTerm"
#define kWOASrvKeyForSubjectClassArray @"classSubjects"
#define kWOASrvKeyForSubjectClassName @"className"
#define kWOASrvKeyForSubjectClassID @"classID"
#define kWOASrvKeyForSubjectArray @"mySubjects"
#define kWOASrvKeyForSubjectWeekday @"week"
#define kWOASrvKeyForSubjectStep @"step"
#define kWOASrvKeyForSubjectID @"subjectID"
#define kWOASrvKeyForSubjectName @"subjectName"
#define kWOASrvKeyForSubjectDate @"date"
#define kWOASrvKeyForSubjectAvailableDate @"date"
#define kWOASrvKeyForSubjectTeacherID @"teacherID"
#define kWOASrvKeyForSubjectTeacherName @"teacherName"
#define kWOASrvKeyForSubjectChangeCode @"changeCode"
#define kWOASrvKeyForSubjectChangeStyle @"changeStyle"
#define kWOASrvKeyForSubjectChangeReason @"reason"
#define kWOASrvKeyForSubjectChangeContent @"content"
#define kWOASrvKeyForSubjectChangeAdvice @"advice"
#define kWOASrvKeyForSubjectNewSubjectID @"newSubjectID"
#define kWOASrvKeyForSubjectNewTeacherID @"newTeacherID"

#define kWOASrvValueForSubjectDateFormat @"YYYY/M/d"

#define kWOASrvKeyForSyllabusSectionName @"name"
#define kWOASrvKeyForSyllabusClassList @"classList"

#define kWOASrvKeyForContactName @"name"
#define kWOASrvKeyForContactPhoneNumber @"telephone"

#define kWOASrvKeyForSalarySumup @"sumPayoff"
#define kWOASrvKeyForSalaryYear @"year"
#define kWOASrvKeyForSalaryMonth @"month"
#define kWOASrvKeyForSalaryItemDate @"itemDate"
#define kWOASrvKeyForSalaryItemArray @"payoffItems"
#define kWOASrvKeyForSalaryTitleArray @"titleItems"
#define kWOASrvKeyForSalaryValueArray @"valueItems"
#define kWOASrvKeyForSalaryItemName @"itemName"



#define kWOASrvKeyForAttdCompulsoryArray @"compulsoryItems"
#define kWOASrvKeyForAttdOptionalArray @"optionalItems"
#define kWOASrvKeyForAttdStyle @"attendanceStyle"
#define kWOASrvValueForAttdStyleCompulsory @"compulsory"
#define kWOASrvValueForAttdStyleOptional @"optional"
#define kWOASrvKeyForAttdItemName @"name"
#define kWOASrvKeyForAttdItemClassID @"bjid"
#define kWOASrvKeyForAttdItemStepName @"zxmc"
#define kWOASrvKeyForAttdItemSubjectName @"kcmc"
#define kWOASrvKeyForAttdItemTermName @"xqmc"
#define kWOASrvKeyForAttdOpItemsArray @"attItems"
#define kWOASrvKeyForAttdStepList @"zxmcList"
#define kWOASrvKeyForAttdStudentList @"studentList"
#define kWOASrvKeyForAttdStudentName @"name"
#define kWOASrvKeyForAttdStudentID @"id"
#define kWOASrvKeyForAttdStudentStatus @"value"
#define kWOAKeyForAttdStepFullName @"_stepFullName"

#define kWOASrvKeyForStdEvalClassItems @"classItems"
#define kWOASrvKeyForStdEvalGradeInfo @"grade"
#define kWOASrvKeyForStdEvalClassInfoArray @"class"
#define kWOASrvKeyForStdEvalClassID @"classID"
#define kWOASrvKeyForStdEvalClassName @"className"
#define kWOASrvKeyForStdEvalStudentList @"studentItems"
#define kWOASrvKeyForStdEvalStudentSeatNo @"seatNo"
#define kWOASrvKeyForStdEvalStudentName @"name"
#define kWOASrvKeyForStdEvalStudentID @"studentID"
#define kWOASrvKeyForStdEvalStudentEvals @"eval"
#define kWOASrvKeyForStdEvalItemList @"evalList"
#define kWOASrvKeyForStdEvalItemID_Get @"id"
#define kWOASrvKeyForStdEvalItemID_Post @"evalID"
#define kWOASrvKeyForStdEvalItemDate @"date"
#define kWOASrvKeyForStdEvalItemContent_Get @"content"
#define kWOASrvKeyForStdEvalItemContent_Post @"context"

#define kWOASrvKeyForQutEvalSchoolYearArray @"schoolYear"
#define kWOASrvKeyForQutEvalSchoolYear @"schoolYear"
#define kWOASrvKeyForQutEvalTermArray @"terms"
#define kWOASrvKeyForQutEvalTerm @"term"
#define kWOASrvKeyForQutEvalEvalItems @"evalItems"
#define kWOASrvKeyForQutEvalEvalItemID @"evalItemID"
#define kWOASrvKeyForQutEvalSubItems @"subItems"
#define kWOASrvKeyForQutEvalItemInfo @"itemName"
#define kWOASrvKeyForQutEvalItemScore_Get @"evalScore"
#define kWOASrvKeyForQutEvalItemScore_Post @"score"
#define kWOASrvKeyForQutEvalStyle @"evalStyle"
#define kWOASrvKeyForQutEvalItemScore @"evalScore"
#define kWOASrvKeyForQutEvalClassType @"classIfication"
#define kWOASrvValueForQutEvalClassType_Std @"1"
#define kWOASrvValueForQutEvalClassType_Society @"2"
#define kWOASrvKeyForQutEvalClassItems @"classItems"
#define kWOASrvKeyForQutEvalGradeInfo @"grade"
#define kWOASrvKeyForQutEvalClassInfo @"class"
#define kWOASrvKeyForQutEvalSocietyID @"itemID"
#define kWOASrvKeyForQutEvalSocietyName @"name"
#define kWOASrvKeyForQutEvalClassItemID @"classItemID"
#define kWOASrvKeyForQutEvalStudentList @"studentItems"
#define kWOASrvKeyForQutEvalGradeClass @"gradeClass"
#define kWOASrvKeyForQutEvalStudentSeatNum @"seatNo"
#define kWOASrvKeyForQutEvalStudentID @"studentID"
#define kWOASrvKeyForQutEvalStudentName @"name"
#define kWOASrvKeyForQutEvalComment @"memotxt"
#define kWOASrvKeyForQutEvalAttfile @"attfile"


#define kWOASrvKeyForAttachmentTitle @"title"
#define kWOASrvKeyForSendAttachmentTitle @"att_title"
#define kWOASrvKeyForAttachmentUrl @"url"
#define kWOASrvKeyForAttachmentFilePath @"filePath"
#define kWOASrvKeyForAttachmentRetUrl @"ret_file"

#define kWOASrvKeyForProcessID @"processID"
#define kWOASrvValueForProcessIDDone @"0"


////////////////////////////////////////
//Student
#define kWOA_Level_1_Seperator @"|"
#define kWOA_Level_2_Seperator @","

#define kWOAStudContentParaValue @"para_value"

#define kWOAStudSrvKeyForItemID @"id"
#define kWOAStudSrvKeyForItemType @"type"




