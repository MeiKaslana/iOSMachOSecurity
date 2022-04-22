#import <Foundation/Foundation.h>
@interface JudgeReverse : NSObject
/*!
 * @method getCryptid
 * Provides the value of "Crypt id" in the mach-o
 * Crypt id为0即未未加密，说明遭到了逆向
 * 逆向的砸壳步骤是通过获取加载在手机内存中的解密数据实现的
 * 这种方法获取的mach-o的Crypt id为0
 * 上传app store的包被苹果加壳后Crypt id为1，代表要解密
 * 没有加密解密手段，即使强行修改macho的Crypt id值
 * 解密未解密的mach-o也会出问题
 */
+ (int)getCryptid;
/*!
 * @method getLoadDylib
 * Provides the quantity of LC_LOAD_DYLIB in the mach-o
 *  保证LC_LOAD_DYLIB数量和打包的时候一致，被dylib注入的话
 *  LC_LOAD_DYLIB数量会比打包的时候多
 */
+ (int)getLoadDylib;
@end
