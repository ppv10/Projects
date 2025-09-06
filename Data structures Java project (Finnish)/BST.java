public class BST {

    public class Node {
        // luokan Node ilmentymamuuttuja
        public int avain;
        public int tieto;
        public Node left, right;

        // konstruktori
        public Node(int avain, int tieto) {
            this.avain = avain;
            this.tieto = tieto;
            this.left = this.right = null;
        }

    }
    // ilmentymamuuttuja
    public Node root;

    // root on null oletuksena
    public BST() {
        this.root = null;
    }

    // insert-metodi uuden tiedon syottamiselle
    public void insert(int avain, int tieto) {
        this.root = insert(root, avain, tieto);
    }

    public Node insert(Node root, int avain, int tieto) {
        // jos juuri on null, tulee syotetysta tiedosta juuri
        if (root == null) {
            root = new Node(avain, tieto);
            return root;
        }
        // jos juuren arvo on suurempi tai yhta suuri kuin syotettava, laitetaan se vasemmalle puolelle
        if (root.avain >= avain) {
            root.left = insert(root.left, avain, tieto);
        } else { // muutoin oikealle
            root.right = insert(root.right, avain, tieto);
        }
        return root;
    }

    public void delete(int avain) { // kayttajan aktivoima delete-operaatio
        root = deleteRec(root, avain);
    }

    Node deleteRec(Node root, int avain) {
        if (root == null)  return root;

        if (avain < root.avain) // jos avain on pienempi kuin juuri, poistetaan
                                // vasemman puoleinen lapsi
            root.left = deleteRec(root.left, avain);
        else if (avain > root.avain) //jos avain on suurempi kuin juuri, poistetaan
                                    // oikean puoleinen lapsi
            root.right = deleteRec(root.right, avain);
        else {
            if (root.left == null) // jos juurella on lapsia ja ne ovat oikealla puolella, palautetaan ne
                return root.right;
            else if (root.right == null) // jos juurella on lapsia ja ne ovat vasemmalla puolella, palautetaan ne
                return root.left;

            root.avain = minValue(root.right);

            root.right = deleteRec(root.right, root.avain);
        }

        return root;
    }

    int minValue(Node root) { // palauttaa puun vasemmanpuoleisimman, eli pienimman arvon
        int minv = root.avain;
        while (root.left != null) {
            minv = root.left.avain;
            root = root.left;
        }
        return minv;
    }

    // Kulku puussa
    public void inorder() {
        inorder(root);
    }

    public static void inorder(Node root) { //rekursiivinen sisatulostus
        // metodi paattyy, jos puu on tyhja
        if (root == null) {
            return;
        }

        // Kaydaan lapi vasen puoli puusta
        inorder(root.left);

        // Tulostaa jokaisen solmun tiedon rekursiivisessa jarjestyksessa
        System.out.print(root.tieto + ",");

        // Kaydaan lapi oikea puoli puusta
        inorder(root.right);
    }

    public static void main(String[] args) {
        // luodaan BinarySearchTree luokan olio bst
        BST bst = new BST();
        // kutsutaan olion bst metodia insert,
        // taytetaan avain ja tieto
        bst.insert(2, 1);
        bst.insert(4, 2);
        bst.insert(1, 3);
        bst.insert(3, 4);
        bst.insert(5, 5);
        /*
        Puu on seuraavan muotoinen, avain on solmun arvo
        ja tieto on suluissa solmujen vieressä:
                    2 (1)
                   / \
              (3) 1   4 (2)
                     / \
                (4) 3   5 (5)
         */
        bst.inorder();// tieto tulostuu rekursiivisessa sisatulostusjarjestyksessa (3,1,4,2,5)
        bst.delete(2);
        System.out.println();
        bst.inorder(); // tieto tulostuu ilman avaimen 3 arvoa (3,1,2,5)
    }

}