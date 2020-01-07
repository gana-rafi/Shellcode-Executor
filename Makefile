OBJECT_DIR	:= obj
INCLUDE_DIR := inc
OUT_DIR		:= out
PROG		:= shellcode_executer
SUB_DIR	 =

CFLAGS  := -z execstack 
LDFLAGS := -z execstack
CC		:= gcc 
ECHO	= @echo "going to compile for target $@"

OS := $(shell uname)
ifneq (,$(findstring CYGWIN_NT,$(OS)))
	EXT := .exe
else
	EXT :=
endif

SRC		 := $(wildcard *.c)			   # list of source files

ifneq ($(notodo), 1)
TODOS    := $(shell grep -nF TODO $(SRC))
ifdef TODOS
$(info There are unattended TODO tags: (to disable, add argement 'notodo=1'))
$(error $(TODOS))
endif
endif

.PHONY: clean all dirs debug release


release: SUB_DIR := release
release: all

dirs:
	mkdir -p $(OBJECT_DIR) $(OUT_DIR)/$(SUB_DIR)

debug: SUB_DIR := debug
debug: CFLAGS += -DDEBUG -g
debug: LDFLAGS += -DDEBUG -g
debug: all

OBJS := $(patsubst %.c, $(OBJECT_DIR)/%.o, $(SRC)) # list of object files

.SECONDEXPANSION:
EXEC = $(OUT_DIR)/$(SUB_DIR)/$(PROG)$(EXT)
.DEFAULT_GOAL := 
all: dirs $(EXEC) 

$(OBJECT_DIR)/%.o: %.c
	$(ECHO)
	$(CC) -c -o $@ $< $(CFLAGS)

$(EXEC): $(OBJS) 
	$(CC) -o $(EXEC) $^ $(LDFLAGS)

clean:
	rm -vfr $(EXEC) $(OUT_DIR)/debug $(OUT_DIR)/release $(OBJECT_DIR)/*.o

