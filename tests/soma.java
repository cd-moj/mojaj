import java.io.*;


class Main {

    public static void main(String[] args) {

	BufferedReader	inReader;
        inReader = new BufferedReader(new InputStreamReader(System.in));
        String line;
        int soma = 0;
	int numeros;

	String line2 ;


        try {
	      line2 = inReader.readLine();
              numeros= Integer.parseInt(line2);

	       for (int i = 0 ; i < numeros; i++){
		        line = inReader.readLine();
                        soma += Integer.parseInt(line);


            }
            System.out.println(soma);
            inReader.close();
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }


    }
}
