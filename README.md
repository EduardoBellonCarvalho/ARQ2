# Interface de Debug em Hardware (FPGA DE0-CV) para Processadores RISC-V 
### Este projeto implementa um módulo de Debug e Monitoramento para um processador RISC-V Pipeline de 5 estágios.
### O objetivo não é apenas rodar o processador, mas fornecer ferramentas físicas na placa FPGA que permitam enxergar o que está acontecendo a cada ciclo

## A interface do hardware:
### Pause No Switch 9: Capacidade de congelar o clock do processador instantaneamente mantendo o estado dos registradores.

### Execução lenta: Controle do clock no Switch 0 garantindo a capacidade de utilizar um clock 1HZ ou um de 50MHZ.

### Decodificador Visual de Instruções: Um módulo combinacional dedicado traduz o código de máquina binário para palavras (ex: Add, Sub, bEq) diretamente nos displays de 7 segmentos controlado pelo Switch 4.

### Inspeção de Registradores: possibilidade de visualizar os registradores críticos (t0, t1) controlados pelo (Switch 1 e 2 respectivamente).

### Visualização do pc: O valor do pc é exibido nos leds da placa.

### Reset: Implementação do reset no key 0.
