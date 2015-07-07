GO_EASY_ON_ME = 1
#THEOS_DEVICE_IP = 192.168.0.14
TARGET=iphone:clang:latest:4.0
ADDITIONAL_CFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = CydiaPullDown
CydiaPullDown_FILES = Tweak.xm
CydiaPullDown_FRAMEWORKS = UIKit Foundation
CydiaPullDown_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Cydia"
