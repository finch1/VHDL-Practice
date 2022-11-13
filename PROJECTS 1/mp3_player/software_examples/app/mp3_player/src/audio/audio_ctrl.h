 // audio_ctrl.h

#include "system.h"
#include "audio_codec_WM8731.h"

#define AUDIO_CODEC_I2C_ADDRESS      0x1A

#define AUDIO_CTRL_REG_LINE_IN_L     0x0
#define AUDIO_CTRL_REG_LINE_IN_R     0x1
#define AUDIO_CTRL_REG_HEADPHONE_L   0x2
#define AUDIO_CTRL_REG_HEADPHONE_R   0x3
#define AUDIO_CTRL_REG_ANG_PATH_CTRL 0x4
#define AUDIO_CTRL_REG_DIG_PATH_CTRL 0x5
#define AUDIO_CTRL_REG_POWER_DOWN    0x6
#define AUDIO_CTRL_REG_IF_FORMAT     0x7
#define AUDIO_CTRL_REG_SAMPLING_CTRL 0x8
#define AUDIO_CTRL_REG_ACTIVE_CTRL   0x9
#define AUDIO_CTRL_REG_RESET         0xF

#define BCLK_FREQ                   12000000
#define XCK_FREQ                    12000000
#define SAMPLING_RATE               44100 // 44k Sampling

#define AUDIO_CODEC_CONTROLLER_RESET  0x01
#define AUDIO_CODEC_CONTROLLER_ENABLE 0x02

int audio_codec_write_ctrl( unsigned char reg_addr, unsigned short data );
int audio_codec_init_i2c( alt_audio_codec* audio_codec );
int audio_codec_set_headphone_volume( alt_audio_codec* audio_codec, int volume );
int audio_codec_set_headphone_balance( alt_audio_codec* audio_codec, int balance );


