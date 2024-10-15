public class Practice02_MaxNum {
    public static void main(String[] args) throws Exception {

        int maxNum = 0;
        int[] numbers = { 3, 5, 7, 2, 8 };
        for (int num : numbers) {
            if (maxNum < num) {
                maxNum = num;
            }
        }
        System.out.println(maxNum);

    }
}
