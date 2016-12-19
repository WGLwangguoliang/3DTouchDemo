# 3DTouchDemo

### 3DTouch的概述

在日常开发中,我们经常需要使用3D Touch中的两个功能

1. 在主屏幕上对应用图标使用3DTouch操作
2. 在应用程序内对某一控件使用3DTouch操作

<img src="https://raw.githubusercontent.com/WGLwangguoliang/3DTouchDemo/master/3DTouchDemo/Snapshots/3DTouch1.jpeg" width ="320"><br/>

### 3DTouch的添加
#### 静态添加
在info.plist中添加UIApplicationShortcutItems关键字,如下方式配置即可
<img src="https://raw.githubusercontent.com/WGLwangguoliang/3DTouchDemo/master/3DTouchDemo/Snapshots/3DTouch2.jpeg" width ="320"><br/>

#####其中各个关键字解释如下:
UIApplicationShortcutItemType: 快捷可选项的特定字符串(必填)<br/>
UIApplicationShortcutItemTitle: 快捷可选项的标题(必填)<br/>
UIApplicationShortcutItemSubtitle: 快捷可选项的子标题(可选)<br/>
UIApplicationShortcutItemIconType: 快捷可选项的图标(可选)<br/>
UIApplicationShortcutItemIconFile: 快捷可选项的自定义图标(可选)<br/>
UIApplicationShortcutItemUserInfo: 快捷可选项的附加信息(可选)<br/>
#### 动态添加
UIApplicationShortcutItem<br/>
每一个快捷可选项是一个UIApplicationShortcutItem对象,其指定初始化器(NS_DESIGNATED_INITIALIZER)如下<br/>

 *   (instancetype)initWithType:(NSString *)type localizedTitle:(NSString *)localizedTitle localizedSubtitle:(nullable NSString *)localizedSubtitle icon:(nullable UIApplicationShortcutIcon *)icon userInfo:(nullable NSDictionary *)userInfo;<br/>
#####其中各个参数释义如下:
type: 快捷可选项的特定字符串(必填)<br/>
localizedTitle: 快捷可选项的标题(必填)<br/>
localizedSubtitle: 快捷可选项的子标题(可选)<br/>
icon: 快捷可选项的图标(可选)<br/>
userInfo: 快捷可选项的附加信息(可选)

UIApplicationShortcutIcon<br/>
每一个快捷可选项图标为一个UIApplicationShortcutIcon对象,我们可以使用系统提供的多个图标,也可以自定义我们自己的图标

// 使用系统提供的图标<br/>
+ (instancetype)iconWithType:(UIApplicationShortcutIconType)type;

// 自定义图标<br/>
+ (instancetype)iconWithTemplateImageName:(NSString *)templateImageName;
