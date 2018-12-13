##########
# Colors #
##########

COLOR_RESET   := \033[0m
COLOR_ERROR   := \033[31m
COLOR_INFO    := \033[32m
COLOR_WARNING := \033[33m
COLOR_COMMENT := \033[36m

########
# Help #
########

HELP_INDENT ?= 20

HELP = \
	\nUsage: make [$(MANALA_COLOR_INFO)target$(MANALA_COLOR_RESET)]\n \
	$(call help_section,Help) \
	$(call help,help,This help) \
	\n

define help_section
	\n$(COLOR_COMMENT)$(1):$(COLOR_RESET)
endef

define help
  \n  $(COLOR_INFO)$(1)$(COLOR_RESET) $(2)
endef

help:
	@printf "$(HELP)"
	awk '/^[a-zA-Z\-\_0-9\.@%\/]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "\n  $(COLOR_INFO)%-$(HELP_INDENT)s$(COLOR_RESET) %s", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n\n"

.PHONY: help

######################
# Special Characters #
######################

# Usage:
#   $(call message, Foo$(,) bar) = Foo, bar

, := ,

########
# Time #
########

# Usage:
#   $(call time) = 11:06:20

define time
`date -u +%T`
endef

###########
# Message #
###########

# Usage:
#   $(call message, Foo bar)         = Foo bar
#   $(call message_success, Foo bar) = (っ◕‿◕)っ Foo bar
#   $(call message_warning, Foo bar) = ¯\_(ツ)_/¯ Foo bar
#   $(call message_error, Foo bar)   = (╯°□°)╯︵ ┻━┻ Foo bar

define message
	printf "$(COLOR_INFO)$(strip $(1))$(COLOR_RESET)\n"
endef

define message_success
	printf "$(COLOR_INFO)(っ◕‿◕)っ $(strip $(1))$(COLOR_RESET)\n"
endef

define message_warning
	printf "$(COLOR_WARNING)¯\_(ツ)_/¯ $(strip $(1))$(COLOR_RESET)\n"
endef

define message_error
	printf "$(COLOR_ERROR)(╯°□°)╯︵ ┻━┻ $(strip $(1))$(COLOR_RESET)\n"
endef

#######
# Log #
#######

# Usage:
#   $(call log, Foo bar)         = [11:06:20] [target] Foo bar
#   $(call log_warning, Foo bar) = [11:06:20] [target] ¯\_(ツ)_/¯ Foo bar
#   $(call log_error, Foo bar)   = [11:06:20] [target] (╯°□°)╯︵ ┻━┻ Foo bar

define log
	printf "[$(COLOR_COMMENT)$(call time)$(COLOR_RESET)] [$(COLOR_COMMENT)$(@)$(COLOR_RESET)] " ; $(call message, $(1))
endef

define log_warning
	printf "[$(COLOR_COMMENT)$(call time)$(COLOR_RESET)] [$(COLOR_COMMENT)$(@)$(COLOR_RESET)] "  ; $(call message_warning, $(1))
endef

define log_error
	printf "[$(COLOR_COMMENT)$(call time)$(COLOR_RESET)] [$(COLOR_COMMENT)$(@)$(COLOR_RESET)] " ;  $(call message_error, $(1))
endef

###########
# Confirm #
###########

# Usage:
#   $(call confirm, Foo bar) = ༼ つ ◕_◕ ༽つ Foo bar (y/N):

define confirm
	printf "$(COLOR_INFO) ༼ つ ◕_◕ ༽つ $(COLOR_WARNING)$(strip $(1)) $(COLOR_RESET)$(COLOR_WARNING)(y/N)$(COLOR_RESET): "; \
	read CONFIRM ; if [ "$$CONFIRM" != "y" ]; then printf "\n"; exit 1; fi
endef

########
# Exit #
########

# Usage:
#   $(call exit_if_not, $(FOO), FOO has not been specified) = (╯°□°)╯︵ ┻━┻ FOO has not been specified

define exit_if_not
	$(if $(strip $(1)),, \
		$(call message_error, $(strip $(2))) ; exit 1 \
	)
endef
