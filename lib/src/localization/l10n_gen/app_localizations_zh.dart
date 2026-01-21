// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'MD Bro';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get ok => '确定';

  @override
  String get confirm => '确认';

  @override
  String get loading => '加载中...';

  @override
  String get success => '成功';

  @override
  String get error => '错误';

  @override
  String get undo => '撤销';

  @override
  String get retry => '重试';

  @override
  String get settings => '设置';

  @override
  String get general => '通用';

  @override
  String get tasks => '任务';

  @override
  String get memos => '微博客 (Memos)';

  @override
  String get aiAssistant => 'AI 助手';

  @override
  String get language => '语言';

  @override
  String get importDictionary => '导入词典';

  @override
  String get manageDictionaries => '管理词典';

  @override
  String get vaultFolderPrompt => '包含任务的 Obsidian Vault 文件夹：';

  @override
  String get select => '选择';

  @override
  String get pleaseChooseFolder => '<请选择文件夹>';

  @override
  String get storagePermissionRequired => '需要存储权限以选择目录。';

  @override
  String get noExternalStorageFound => '未找到外部存储目录。';

  @override
  String get showOnboarding => '显示引导页：';

  @override
  String get showOnboardingDesc => '开启后，应用启动时将显示引导页';

  @override
  String get dailyReminderTasks => '每日任务回顾提醒：';

  @override
  String get dailyReminderCompleted => '每日完成任务回顾提醒：';

  @override
  String get time => '时间：';

  @override
  String get notSet => '未设置';

  @override
  String get clearReminder => '清除提醒';

  @override
  String get reviewTasksNotification => '回顾您的任务（您可以在设置中移除此提醒）';

  @override
  String get reviewCompletedNotification => '回顾已完成的任务（您可以在设置中移除此提醒）';

  @override
  String get tasksFileName => '新增任务的文件名（位于下方路径中）：';

  @override
  String get globalTaskFilter => '全局任务过滤器：';

  @override
  String get enterGlobalFilter => '输入全局任务过滤器，例如 #task';

  @override
  String get memosPath => 'Memos 路径：';

  @override
  String get memosPathDesc =>
      '静态路径（如 memos.md）或带有日期变量的动态路径（如 <YYYY>/<YYYY-MM-DD>.md）';

  @override
  String get dynamicPath => '动态路径：';

  @override
  String get dynamicPathDesc => '如果路径包含 <YYYY-MM-DD> 等日期变量，请启用';

  @override
  String get widgetSortOrder => '小部件排序顺序：';

  @override
  String get widgetSortOrderDesc => '升序显示旧的在前；降序显示新的在前';

  @override
  String get asc => '升序';

  @override
  String get desc => '降序';

  @override
  String get memosAttachmentDir => '附件目录 (Asset Directory)：';

  @override
  String get memosAttachmentDirDesc =>
      '相对于 Vault 的路径，支持日期变量。例如: assets 或 <YYYY>/assets';

  @override
  String get enterMemosAttachmentDir => '例如: assets 或 <YYYY>/assets';

  @override
  String get imageCompression => '图片压缩';

  @override
  String get enableCompression => '启用压缩';

  @override
  String get enableCompressionDesc => '保存到 Vault 前压缩图片';

  @override
  String get format => '格式';

  @override
  String get quality => '质量：';

  @override
  String get microblogPublishing => '微博客发布配置';

  @override
  String get microblogFilename => '文件名 (Vault 内)';

  @override
  String get microblogTitle => '博客标题';

  @override
  String get microblogPermalink => 'DG 该问链接 (Slug)';

  @override
  String get microblogPermalinkHelper =>
      'Permanent link suffix (e.g., mysite.com/microblog)';

  @override
  String get microblogTag => '过滤标签';

  @override
  String get microblogAvatarPath => '头像路径 (Vault 内)';

  @override
  String get microblogUsername => '用户名';

  @override
  String get pushConfig => '推送配置 (GitHub)';

  @override
  String get repoUrl => '仓库 URL';

  @override
  String get repoPath => '仓库内目标路径';

  @override
  String get repoImagePath => '仓库内图片路径';

  @override
  String get webImagePrefix => 'Web 图片前缀';

  @override
  String get personalAccessToken => '个人访问令牌 (PAT)';

  @override
  String get enterBaseUrl => '输入 Base URL (可选)';

  @override
  String get enterApiKey => '输入 API Key';

  @override
  String get aiBaseUrl => 'Base URL (例如 https://api.openai.com/v1)：';

  @override
  String get aiApiKey => 'API Key：';

  @override
  String get aiModelName => '模型名称 (例如 gpt-4o)：';

  @override
  String get about => 'About';

  @override
  String get contactDeveloper => '联系开发者：';

  @override
  String get version => '版本：';

  @override
  String couldNotLaunch(Object url) {
    return '无法打开 $url';
  }

  @override
  String get memosAttachmentDirNotConfigured => '请先在设置中配置 Memos 附件目录';

  @override
  String get vaultNotConfigured => '请先配置 Vault 目录';

  @override
  String attachmentSaved(Object path) {
    return '附件已保存到：$path';
  }

  @override
  String attachmentSaveFailed(Object error) {
    return '保存附件失败：$error';
  }

  @override
  String get microblogNotConfigured => '请先在设置中配置微博发布信息 (Repo, Token, Path)';

  @override
  String get publishMicroblog => '发布微博客';

  @override
  String publishConfirmation(Object tag) {
    return '即将聚合带有 $tag 的 Memos 并推送到 GitHub。\n确定继续吗？';
  }

  @override
  String get publish => '发布';

  @override
  String get publishing => '正在生成并推送...';

  @override
  String get pushingContent => '正在推送内容...';

  @override
  String get noAttachmentsUpdated => '没有附件更新';

  @override
  String attachmentsUploaded(Object count, Object message) {
    return '已上传 $count 个附件：$message';
  }

  @override
  String newAttachments(Object count) {
    return '新增 $count 个附件';
  }

  @override
  String publishSuccess(Object message) {
    return '发布成功！$message';
  }

  @override
  String publishFailed(Object error) {
    return '发布失败：$error';
  }

  @override
  String editingTime(Object time) {
    return '正在编辑 $time';
  }

  @override
  String get deleteImage => '删除图片';

  @override
  String get deleteImageConfirmation => '确定要删除这张图片吗？这将从你的 Vault 中永久删除该文件。';

  @override
  String get imageDeleted => '图片已删除';

  @override
  String get filterStatus => '状态';

  @override
  String get filterScheduledDate => '计划日期';

  @override
  String get filterDueDate => '截止日期';

  @override
  String get filterTag => '标签';

  @override
  String get filterPath => '路径';

  @override
  String get filterPriority => '优先级';

  @override
  String get opAny => '任意';

  @override
  String get opIs => '是';

  @override
  String get opIsNot => '不是';

  @override
  String get opIsBefore => '早于';

  @override
  String get opIsAfter => '晚于';

  @override
  String get opIsToday => '是今天';

  @override
  String get opIsBeforeToday => '早于今天';

  @override
  String get opIsAfterToday => '晚于今天';

  @override
  String get opIsInNextDays => '在未来几天内';

  @override
  String get opIsInPrevDays => '在过去几天内';

  @override
  String get opIsEmpty => '为空';

  @override
  String get opIsNotEmpty => '不为空';

  @override
  String get taskStatusAll => '全部';

  @override
  String get taskStatusTodo => '待办';

  @override
  String get taskStatusDone => '已完成';

  @override
  String get labelMatch => '匹配';

  @override
  String get labelAll => '全部';

  @override
  String get labelAny => '任意';

  @override
  String get labelConditions => '条件';

  @override
  String get btnAddCondition => '添加条件';

  @override
  String get hintDays => '天数';

  @override
  String get hintTag => '标签';

  @override
  String get hintPath => '路径';

  @override
  String get hintPriority => '1-5';

  @override
  String get btnSelectDate => '选择日期';

  @override
  String get msgEnterFilterName => '请输入筛选名称';

  @override
  String get titleNewFilter => '新建筛选';

  @override
  String get titleEditFilter => '编辑筛选';

  @override
  String get labelFilterName => '筛选名称';

  @override
  String get headerFilterConditions => '筛选条件';

  @override
  String get memosToday => '今天';

  @override
  String get memosYesterday => '昨天';

  @override
  String get btnSelectMonth => '选择月份';

  @override
  String get labelYear => '年份';

  @override
  String get labelMonth => '月份';

  @override
  String get labelInheritDate => '从文件名获取日期';

  @override
  String get labelTagsInclude => '包含标签';

  @override
  String get labelTagsExclude => '排除标签';

  @override
  String get hintEnterTag => '输入标签后回车';

  @override
  String get labelPathContains => '路径包含';

  @override
  String get hintPathExample => '例如：Work/Projects';

  @override
  String get labelGroupBy => '分组方式';

  @override
  String get groupNone => '不分组';

  @override
  String get groupDueDate => '截止日期';

  @override
  String get groupScheduledDate => '计划日期';

  @override
  String get groupFilePath => '文件路径';

  @override
  String get groupPriority => '优先级';

  @override
  String get groupStatus => '状态';

  @override
  String get labelSortRules => '排序规则';

  @override
  String get sortAsc => '升序';

  @override
  String get sortDesc => '降序';

  @override
  String get sortAlphabetical => '字母顺序';

  @override
  String get sortCreatedDate => '创建日期';

  @override
  String get btnAddSortRule => '添加排序规则';

  @override
  String get headerNewTaskDefaults => '新任务默认设置';

  @override
  String get labelDefaultTags => '默认标签';

  @override
  String get hintDefaultTag => '输入默认标签';

  @override
  String get labelDefaultDueDate => '默认截止日期';

  @override
  String get labelOffsetDays => '偏移天数 (0=今天)';

  @override
  String get labelSpecificDate => '指定日期';

  @override
  String get datePresetNone => '无';

  @override
  String get datePresetToday => '今天';

  @override
  String get datePresetTomorrow => '明天';

  @override
  String get datePresetTodayPlusDays => '今天 + 天数';

  @override
  String get actionKeep => '保留';

  @override
  String get actionDelete => '删除';

  @override
  String get actionArchive => '归档';

  @override
  String get titleManageFilters => '管理筛选列表';

  @override
  String get labelWidgetDisplay => '桌面组件显示';

  @override
  String get labelDefault => '默认';

  @override
  String confirmDeleteFilter(String name) {
    return '确定要删除 \"$name\" 吗？';
  }

  @override
  String get titleDeleteFilter => '删除筛选';

  @override
  String get titleSelectWidgetFilter => '选择组件筛选器';

  @override
  String get labelCompletionAction => '完成时动作';

  @override
  String get headerTaskStatus => '任务状态';

  @override
  String get labelTask => '任务';

  @override
  String get labelTaskDescription => '任务描述';

  @override
  String get hintEnterTask => '在此输入任务内容';

  @override
  String get labelTags => '标签';

  @override
  String get msgNoTagsAvailable => '暂无可用标签';

  @override
  String get headerPlanning => '计划';

  @override
  String get labelPriority => '优先级';

  @override
  String get labelRecurrence => '重复';

  @override
  String get labelDue => '截止';

  @override
  String get labelScheduled => '计划';

  @override
  String get labelStart => '开始';

  @override
  String get headerNotifications => '通知';

  @override
  String get labelScheduledNotification => '计划通知';

  @override
  String get headerStatusMetadata => '状态与元数据';

  @override
  String get labelStatus => '状态';

  @override
  String get labelCreated => '创建于';

  @override
  String get labelDone => '完成于';

  @override
  String get labelCancelled => '取消于';

  @override
  String get priorityLowest => '最低';

  @override
  String get priorityLow => '低';

  @override
  String get priorityNormal => '普通';

  @override
  String get priorityMedium => '中';

  @override
  String get priorityHigh => '高';

  @override
  String get priorityHighest => '最高';

  @override
  String get taskStatusInprogress => '进行中';

  @override
  String get taskStatusCancelled => '已取消';

  @override
  String get recurrenceNone => '无';

  @override
  String get recurrenceDaily => '每天';

  @override
  String get recurrenceWeekly => '每周';

  @override
  String get recurrenceMonthly => '每月';

  @override
  String get recurrenceYearly => '每年';

  @override
  String get recurrenceWeekday => '每个工作日';

  @override
  String get recurrenceMonday => '每周一';

  @override
  String get recurrenceTuesday => '每周二';

  @override
  String get recurrenceWednesday => '每周三';

  @override
  String get recurrenceThursday => '每周四';

  @override
  String get recurrenceFriday => '每周五';

  @override
  String get recurrenceSaturday => '每周六';

  @override
  String get recurrenceSunday => '每周日';

  @override
  String deleteFailed(Object error) {
    return '删除失败: $error';
  }

  @override
  String get enterModelName => '输入模型名称';

  @override
  String get dictionaryImported => '字典导入成功';

  @override
  String dictionaryImportFailed(Object error) {
    return '导入字典失败: $error';
  }

  @override
  String get memoHint => '你现在在想什么？';

  @override
  String get memoEditHint => '修改内容...';

  @override
  String get insertTag => '插入标签 #';

  @override
  String get insertWikiLink => '插入链接 [[]]';

  @override
  String get addAttachment => '添加附件';

  @override
  String get jumpToDate => '跳转到日期';

  @override
  String get shareImageError => '缓存中未找到图片路径';

  @override
  String get manageFilters => '管理筛选';

  @override
  String get deleteFilter => '删除筛选';

  @override
  String deleteFilterConfirmation(Object name) {
    return '确定要删除 \"$name\" 吗？';
  }

  @override
  String get selectWidgetFilter => '选择小部件筛选器';

  @override
  String get defaultFilter => '默认';

  @override
  String get widgetDisplay => '桌面小部件显示';

  @override
  String get filterName => '筛选名称';

  @override
  String get taskStatus => '任务状态';

  @override
  String matchConditions(Object mode) {
    return '匹配 $mode 条件';
  }

  @override
  String get allMode => '所有 (ALL)';

  @override
  String get anyMode => '任意 (ANY)';

  @override
  String get addFilterGroup => '添加筛选组';

  @override
  String get addCondition => '添加条件';

  @override
  String get inheritDate => '从文件名继承日期';

  @override
  String get includeTags => '包含标签';

  @override
  String get excludeTags => '排除标签';

  @override
  String get enterTagHint => '输入标签后点击添加';

  @override
  String get pathContains => '文件路径包含';

  @override
  String get groupBy => '分组方式 (Group By)';

  @override
  String get none => '不分组 (None)';

  @override
  String get dueDate => '截止日期 (Due Date)';

  @override
  String get scheduledDate => '计划日期 (Scheduled Date)';

  @override
  String get filePath => '文件路径 (File Path)';

  @override
  String get priority => '优先级 (Priority)';

  @override
  String get status => '状态 (Status)';

  @override
  String get sortRules => '排序规则 (优先级从上到下)';

  @override
  String get ascending => '升序 (Asc)';

  @override
  String get descending => '降序 (Desc)';

  @override
  String get createdDate => '创建日期';

  @override
  String get alphabetical => '字母顺序';

  @override
  String get enterFilterName => '请输入筛选名称';

  @override
  String get filterTasks => '筛选任务...';

  @override
  String get newFilter => '新建筛选';

  @override
  String get editFilter => '编辑筛选';

  @override
  String aiDataReview(Object name) {
    return '数据审核：$name';
  }

  @override
  String get aiDataReviewDesc => '以下数据将发送给 AI，请检查是否包含敏感信息：';

  @override
  String get noData => '(无数据)';

  @override
  String get reject => '拒绝';

  @override
  String get approve => '批准';

  @override
  String get approved => '✅ 用户已批准发送此数据';

  @override
  String get rejected => '❌ 用户已拒绝发送此数据';

  @override
  String get editData => '编辑数据';

  @override
  String get editDataHint => '编辑要发送给 AI 的数据...';

  @override
  String get sendEdited => '发送编辑后的数据';

  @override
  String get apiKeyMissing => '❌ API Key 未配置。请在设置页面的 AI 助手分类中填写 API Key。';

  @override
  String get todayTaskDefaults => '今日任务默认设置';

  @override
  String newTaskDefaults(Object name) {
    return '新任务默认设置 ($name)';
  }

  @override
  String get setDate => '设置日期';

  @override
  String get setTime => '设置时间';
}
