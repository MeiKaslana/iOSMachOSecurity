#import "JudgeReverse.h"
#import <mach-o/dyld.h>
@implementation JudgeReverse

+ (int)getCryptid{
    const struct mach_header_64 *mach_o = (struct mach_header_64 *)_dyld_get_image_header(0);
        
    const struct load_command *cmds = (const struct load_command *)(mach_o + 1);
    const struct load_command *lc = cmds;
    for(uint32_t i = 0; i < mach_o->ncmds; lc = (void *) ((char *) lc + lc->cmdsize)) {
        if(lc->cmd == LC_ENCRYPTION_INFO_64) {
            struct encryption_info_command *crypt_cmd = (struct encryption_info_command *) lc;
            return crypt_cmd->cryptid;
        }
    }
    return -1;
}

+ (int)getLoadDylib{
    int dylibcount=0;
    const struct mach_header_64 *mach_o = (struct mach_header_64 *)_dyld_get_image_header(0);
        
    const struct load_command *cmds = (const struct load_command *)(mach_o + 1);
    const struct load_command *lc = cmds;
    for(uint32_t i = 0; i < mach_o->ncmds; i++,lc = (void *) ((char *) lc + lc->cmdsize)) {
        if(lc->cmd == LC_LOAD_DYLIB) {
            dylibcount++;
            #ifndef __LP64__
            //32位系统的struct dylib没有ptr，只有offset，
            //而且不同LC_LOAD_DYLIB的offset也都相同，没有意义
            //只有在64位系统下才能获取动态库的char *ptr
            //32位系统想通过这个方法判断是否被注入的话只能获取到动态库的数量dylibcount
            struct dylib_command *dylib_cmd = (struct dylib_command *) lc;
            NSLog(dylib_cmd->dylib.name.ptr);
            #endif
        }
    }
    return dylibcount;
}

@end
