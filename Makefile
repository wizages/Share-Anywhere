include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ShareAnywhere
ShareAnywhere_FILES = $(wildcard *xm)  LetsTakePicturesViewController.m $(wildcard LLSimpleCamera/*m)

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = ShareAnywhereBundle
ShareAnywhereBundle_INSTALL_PATH = /Library/Application Support/

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
