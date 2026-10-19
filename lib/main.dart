import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatefulWidget {
  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  // 1. Estado inicial com termos do negócio de lanches
  String veiculoSelecionado = "Econômico";
  bool seguroCompleto = false; 
  bool gps = false;    
  bool motoristaAdicional = false;    
  double quantidadeDias = 1;    

  // 2. Funções de alteração de estado com nomenclatura técnica
  void mudarVeiculo(String novoVeiculo) {
    setState(() {
      veiculoSelecionado = novoVeiculo;
    });
  }

  void mudarSeguro(bool valor) {
    setState(() {
      seguroCompleto = valor; // CORRIGIDO: alterado de 'valor!' para 'novoValor'
    });
  }

  void mudarGps(bool valor) {
    setState(() {
      gps = valor;
    });
  }

  void mudarMotorista(bool valor) {
    setState(() {
      motoristaAdicional = valor;
    });
  }

  void mudarDias(double valor) {
    setState(() {
      quantidadeDias = valor;
    });
  
  }

  // 3. Função para calcular o preço total do pedido
  double calcularValorDiario() {
    double valorVeiculo = 0;

    if (veiculoSelecionado == "Econômico") {
      valorVeiculo = 120;
    
   } else if (veiculoSelecionado == "SUV") {
    valorVeiculo = 180;
   
   } else if (veiculoSelecionado == "Luxo") {
    valorVeiculo = 300;
   }
    

    double valorSeguro = seguroCompleto ? 40 : 0;
    double valorGps = gps ? 15 : 0;

    // Fórmula: (Lanche + Queijo) * Quantidade + Entrega
    return (valorVeiculo + valorSeguro + valorGps);
  }

  double calcularValorBruto() {
    double valor = calcularValorDiario() * quantidadeDias;

    if(motoristaAdicional){
      valor += 100;
    }

    return valor;
  }

  double calcularDesconto() {
    double desconto = 0;

    if (quantidadeDias >= 15){
      desconto = 0.10;
    } else if (quantidadeDias >= 7){
      desconto = 0.05;

    }

    return calcularValorBruto() * desconto;
  }

  double calcularValorFinal() {
    return calcularValorBruto() - calcularDesconto();
  }

  String mostrarDinheiro(double valor) {
    return "R\${valor.toStringAsFixed(2).replaceAll('.', ',')}";
  }
  
  String mostrarDescontoPercentual(){
    if (quantidadeDias >= 15) {
      return "10%";
    } else if (quantidadeDias >= 7) {
      return "5%";
    }

    return "0%";
  }

  void finalizarReserva() {
     showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text("Resumo da Locação"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Veículo: $veiculoSelecionado"),
                Text("Quantidade de dias: ${quantidadeDias.toInt()}"),
                Text("Seguro completo: ${seguroCompleto ? 'Sim' : 'Não'}"),
                Text("GPS: ${gps ? 'Sim' : 'Não'}"),
                Text(
                  "Motorista adicional: ${motoristaAdicional ? 'Sim' : 'Não'}",
                ),
                const Divider(),
                Text("Valor bruto: ${mostrarDinheiro(calcularValorBruto())}"),
                Text("Desconto (${mostrarDescontoPercentual()}): "
                    "${mostrarDinheiro(calcularDesconto())}"),
                const SizedBox(height: 8),
                Text(
                  "Valor final: ${mostrarDinheiro(calcularValorFinal())}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reserva realizada com sucesso!"),
                  ),
                );
              },
              child: const Text("Confirmar Reserva"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text("Locadora de Carros"),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: const Color(0xFFFBF7FF),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Monte sua Locação",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Escolha o veículo",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        style: SegmentedButton.styleFrom(
                          selectedBackgroundColor: const Color(0xFFE1BEE7),
                          selectedForegroundColor: Colors.black,
                        ),
                        segments: const [
                          ButtonSegment(
                            value: "Econômico",
                            label: Text(
                              "Econômico\nR\$ 120",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ButtonSegment(
                            value: "SUV",
                            label: Text(
                              "SUV\nR\$ 180",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ButtonSegment(
                            value: "Luxo",
                            label: Text(
                              "Luxo\nR\$ 300",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        selected: {veiculoSelecionado},
                        onSelectionChanged: (novaSelecao) {
                          mudarVeiculo(novaSelecao.first);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Opcionais",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.deepPurple,
                      title: const Text("Seguro completo (+ R\$ 40/dia)"),
                      value: seguroCompleto,
                      onChanged: (valor) {
                        mudarSeguro(valor ?? false);
                      },
                    ),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.deepPurple,
                      title: const Text("GPS (+ R\$ 15/dia)"),
                      value: gps,
                      onChanged: (valor) {
                        mudarGps(valor ?? false);
                      },
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Motorista adicional (+ R\$ 100 fixos)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Switch(
                      activeColor: Colors.deepPurple,
                      value: motoristaAdicional,
                      onChanged: (valor) {
                        mudarMotorista(valor);
                      },
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Quantidade de dias: ${quantidadeDias.toInt()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    Slider(
                      min: 1,
                      max: 30,
                      divisions: 29,
                      activeColor: Colors.deepPurple,
                      inactiveColor: Colors.grey,
                      value: quantidadeDias,
                      onChanged: (valor) {
                        mudarDias(valor);
                      },
                    ),

                    const SizedBox(height: 16),

                    const Divider(),

                    const Text(
                      "Resumo da Locação",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text("Veículo: $veiculoSelecionado"),
                    Text("Dias: ${quantidadeDias.toInt()}"),
                    Text("Seguro: ${seguroCompleto ? 'Sim' : 'Não'}"),
                    Text("GPS: ${gps ? 'Sim' : 'Não'}"),
                    Text(
                      "Motorista adicional: "
                      "${motoristaAdicional ? 'Sim' : 'Não'}",
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Valor bruto: ${mostrarDinheiro(calcularValorBruto())}",
                    ),

                    Text(
                      "Desconto (${mostrarDescontoPercentual()}): "
                      "${mostrarDinheiro(calcularDesconto())}",
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Valor final: ${mostrarDinheiro(calcularValorFinal())}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: finalizarReserva,
                        child: const Text(
                          "Finalizar Reserva",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}