LIGO_VERSION = 0.72.0
LIGO = docker run --rm -v "$(PWD)":"$(PWD)" -w "$(PWD)" ligolang/ligo:$(LIGO_VERSION)

# compile_function = $(LIGO) compile contract --syntax pascaligo //a modifier 

######################################################################

help:
	@echo "Ceci est un test !"

######################################################################

all : install ligo-compile ligo-test run-deploy
	@echo "Compiling, testing and deploying code !"

######################################################################

install : 
	@npm --prefix ./scripts/ install

######################################################################

ligo-compile: 
	@echo "Compilation du contrat..."
	@$(LIGO) compile contract ./contracts/main.mligo --output-file ./compiled/main.tz
	@$(LIGO) compile contract ./contracts/main.mligo --michelson-format json --output-file ./compiled/main.json
	@echo "||| COMPILATION SUCCESS |||"

######################################################################

ligo-test: 
	@echo "Test du contrat..."
	@$(LIGO) run test ./tests/ligo/main.test.mligo 

######################################################################

run-deploy : 
	@npm --prefix ./ run deploy

######################################################################

sandbox-start : 
	@sh ./scripts/sandbox_start

sandbox-stop : 	
	@docker stop flexteza-sandbox

sandbox-exec : 	
	@docker exec flexteza-sandbox octez-client list known addresses
	@docker exec flexteza-sandbox octez-client get balance for alice
	@docker exec flexteza-sandbox octez-client get balance for bob
	@docker exec flexteza-sandbox cat /root/.tezos-client/public_keys
	@docker exec flexteza-sandbox cat /root/.tezos-client/secret_keys
