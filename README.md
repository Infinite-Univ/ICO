# Estructura

Estructura de los smart contracts del proyecto :

- Bank.sol : este será el contrato que tendrá toda la logica de distribucion de los tokens,
este contrato holdearía todos los tokens y se encarga de que puedan interactuar con el banco 
y reclamar su porcentaje mensual.

- ERC20 : La unica wallet que puede mintear tokens será ( Bank.sol )

- IPancakeSwap : Conexion para comunicacion con Pancakeswap

# Requerimientos
Modificar el nombre de `.example.env` a `.env` y configurar el archivo `.env` para establecer la `wallet account`

Node version : `v16.20.0`

# Instalacion
```shell
npm install
```

# Comandos ejecutables
Comandos disponibles de utilidad

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
```