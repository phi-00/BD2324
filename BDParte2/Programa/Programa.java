import java.io.File;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Scanner;

public class Programa {


    public static void main(String[] args) {

        //String inicial
        String texto = "Bem-vindo ao programa auxiliar para o Projeto de Base de Dados Parte 2\nEste programa consiste em dar um ficheiro .csv e este programa inserir os dados desse ficheiro automaticamente na Base de Dados\n\nNo ficheiro.csv, a primeira linha deve conter quais os atributos a inserir\n";
        //String que indica como usar o programa
        String uso = "Argumentos: <URL da BD> <User da BD> <Password do User> <Tabela a inserir> <Ficheiro.csv>";

        System.out.println(texto); //Imprimir texto inicial

        if (args.length != 5 ) { //Se não tem os argumentos corretos, sai do programa
            System.out.println("Ocorreu um erro -> Numero de argumentos inválidos");
            System.out.println(uso);
            return;
        }
        
        //Objetos para a conexão com o mySQL
        Connection conexao = null;
        PreparedStatement pre_state = null;

        try {

        //Ter conexão com a Base de Dados
        // URL , USER , PASSWORD
        conexao = DriverManager.getConnection(args[0], args[1], args[2]);

        File fich = new File(args[4]); //Abre o ficheiro.csv
        Scanner sc = new Scanner(fich);

        //Coletar as strings do ficheiro.csv
        ArrayList<String[]> lista = new ArrayList<String[]>();

        while (sc.hasNext()) { //Lê as linhas do .csv
            String linha = sc.nextLine(); //Obtem a linha
            StringBuilder nova = new StringBuilder(linha);
            nova.setCharAt(linha.length()-1,'\0'); //Remove o char de mudança de linha -> '\n'
            String[] itens = nova.toString().split(";"); //Array de Strings com cada item dessa linha
            lista.add(itens); //Meter o array de strings na lista
        }

        //Meter os dados na base de dados
        for (int i=0;i<lista.size();i++) {
            //Se é a primeira linha, então são os atributos que vamos colocar
            if (i==0) {
                StringBuilder insert = new StringBuilder("INSERT INTO ");
                insert.append(args[3]); //Qual a tabela a meter
                insert.append(" (");
                String[] array = lista.get(i); //Obtem o array de strings
                //Meter todos os atributos
                for (int j=0;j<array.length;j++) {
                    if (j>0) insert.append(",");
                    insert.append(array[j]);
                }
                insert.append(") VALUES (");
                //Meter tudo a '?' para quais os dados a inserir
                for (int j=0;j<array.length;j++) {
                    if (j>0) insert.append(",");
                    insert.append("?");
                }
                insert.append(")");

                //Meter a instrução no PrepareStatement
                pre_state = conexao.prepareStatement(insert.toString());

            }
            else {

                //Obter o array de Strings
                String[] array = lista.get(i);
                for (int j=0;j<array.length;j++) {
                    //Inserir os dados
                    pre_state.setString(j+1, array[j]);
                }

                //Atualizar a Base de Dados
                pre_state.executeUpdate();

            }
        }

        System.out.println("Dados inseridos com sucesso!!");

    }
    catch (FileNotFoundException e) {
        System.out.println("Ocorreu um erro -> Ficheiro " + args[4] + " não existe");
        return;
    }
    catch (SQLException e) {
        System.out.println("Ocorreu um erro -> Conexão com a Base de Dados não foi realizada");
        e.printStackTrace();
    }
    finally {
            //Fechar o pre_state e o conexao
            try {
                if (pre_state != null) pre_state.close();
                if (conexao != null) conexao.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }


    }

}
