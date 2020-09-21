import java.util.Arrays;

public class ASM 
{
    
    public static void main(String[] args)
    {
        int[] input= {12,123,1324,13242,92,24,24,56,73,2,35,57,79,99,90,2,1};

        int output[] = new int [input.length];
        int frontiere =0 ;
        int fin=input.length-1;

        for (int i=0;i<input.length;i++)
        {
            if (input[i]%2 == 0)//nombres pairs
            {
                output[frontiere] = input[i];
                frontiere++;
            }
            else //if (input[i]%2 == 1)
            {
                output[fin] = input[i];
                fin--;
            }
        }

        Arrays.sort(output,0,frontiere);
        Arrays.sort(output,frontiere,output.length);
        
        System.out.println("\nVos nombres etaient:\n"+Arrays.toString(input));

        System.out.println("\nDans l'ordre croissant, les nombres pairs multiples de 2 sont:");
        for (int i=0;i<frontiere;i++)
        {
                System.out.print(output[i]);
                System.out.print(" ");
        }

        System.out.println("\n\nDans l'ordre decroissant, les nombres pairs multiples de 3 sont:");
        for (int i= frontiere-1;i > 0;i--)
        {
            if (output[i]%3 == 0 )
            {
                System.out.print(output[i]);
                System.out.print(" ");
            }
            
        }

        System.out.println("\n\nDans l'ordre croissant, les autres nombres sont:");
        for (int i= frontiere;i < output.length;i++)
        {         
                System.out.print(output[i]);
                System.out.print(" ");
                        
        }
        System.out.println("\n");
        
        
        
}
}
