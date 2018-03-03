/*
	Link do site: http://www.andrealveslima.com.br/blog/index.php/2016/09/07/acessando-os-web-services-dos-correios-com-c-e-vb-net-consulta-de-ceps-e-precos/

	Para utilizar esse serviço dos correios, é necessário adicionar um 'Add Service Reference' à classe e no 'Address', adicionar a URL:
	https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl e ir em 'GO'. Selecionar o 'AtendeCliente' e 
	renomear o namespace, aqui, no caso, coloquei 'WsCorreios':
	
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace BuscaCep
{
    class Program
    {
        static void Main(string[] args)
        {
            System.Console.Write("Digite o CEP: ");
            var valor = System.Console.ReadLine();
            try
            {
                var ws = new WsCorreios.AtendeClienteClient();                
                var resposta = ws.consultaCEP(valor);
                System.Console.WriteLine();
                System.Console.WriteLine("Endereço: {0}", resposta.end);
                System.Console.WriteLine("Complemento: {0}", resposta.complemento);
                System.Console.WriteLine("Complemento 2: {0}", resposta.complemento2);
                
                System.Console.WriteLine("Bairro: {0}", resposta.bairro);
                System.Console.WriteLine("Cidade: {0}", resposta.cidade);
                System.Console.WriteLine("Estado: {0}", resposta.uf);
                System.Console.WriteLine("Unidades de Postagem: {0}", resposta.unidadesPostagem);
            }
            catch (Exception ex)
            {
                System.Console.WriteLine("Erro ao efetuar busca do CEP: {0}", ex.Message);
            }
            System.Console.ReadLine();
        }
    }
}
