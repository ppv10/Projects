import java.util.Scanner;
// tuodaan scanner kayttoliittyman switchia varten
class Node {
    int data;
    Node next, prev;

    public Node(int data) {
        this.data = data;
        next = prev = this;  // Solmu on kahdensuuntainen oletuksena
    }
}

class CircularDoublyLinkedList {
    Node head;

    void insert(int data) {
        Node newNode = new Node(data);
        if(find(data) != -1) // jos luku on jo listassa, metodi paatetaan tahan
            return;
        if (head == null) { // jos lista on tyhja, tehdaan siita head-solmu
            head = newNode;
        } else if (data < head.data) {
            // jos listan head-solmu on suurempi kuin syotettava,
            // laitetaan se ensimmaiseksi
            Node last = head.prev;
            newNode.next = head;
            newNode.prev = last;
            head.prev = newNode;
            last.next = newNode;
            head = newNode;
        } else {
            // jos syotettava on suurempi kuin head, etsitaan syotettavalle
            // luvulle paikka listalta
            Node current = head;
            while (current.next != head && current.next.data < data) {
                current = current.next;
            }

            newNode.next = current.next;
            newNode.prev = current;
            current.next.prev = newNode;
            current.next = newNode;
        }
    }

    int find(int data) {
        Node current = head;
        int index = 0;
        if (head != null) { // metodi aloitetaan vain jos lista ei ole tyhja
            do { // listan jokainen luku kaydaan lapi, ja indeksista pidetaan lukua
                if (current.data == data) {
                    return index; // jos luku loytyy, palautetaan indeksi
                }
                current = current.next;
                index++;
            } while (current != head);
        }
        return -1;  // Palauttaa -1, jos koko lista on kayty lapi eika lukua ole
    }

    void delete(int data) {
        Node toDelete = head;
        int index = find(data);
        if (index == -1) { // jos lukua ei loydy listalta, ei metodia suoriteta
            return;
        }

        if(toDelete.next == toDelete){
            head = null;
            return;
        }

        if (index == 0) {
            head = toDelete.next; // jos luku on head, tulee seuraavasta luvusta head
        }

        while(index>0){
                toDelete = toDelete.next;
                index--;
        };

        toDelete.prev.next = toDelete.next; // poistettavan edellisesta tulee osoittaja
        toDelete.next.prev = toDelete.prev; // poistettavan nextiin ja poistettavan seuraavasta
                                            // tulee osoittaja poistettavan edelliseen
    }

    void Print() {
        Node current = head;
        if (head != null) {
            do { // metodi kay jokaisen listan luvun lapi tulostaen ne
                System.out.print(current.data + ",");
                current = current.next;
            } while (current != head);
            System.out.println();
        }
    }

    void PrintInv() {
        Node current = head;
        if (head != null) {
            do { // metodi kay jokaisen luvun lapi listan lopusta alkuun, tulostaen ne
                current = current.prev;
                System.out.print(current.data + ",");
            } while (current != head);
            System.out.println();
        }
    }
}

public class DList {
    public static void main(String[] args) {
        CircularDoublyLinkedList list = new CircularDoublyLinkedList(); // luodaan luokan CircularDList olio list
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("1. Insert");
            System.out.println("2. Delete");
            System.out.println("3. Find");
            System.out.println("4. Print list");
            System.out.println("5. Print list in reverse");
            System.out.println("6. Exit");
            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    System.out.print("Enter the element to insert: ");
                    int data = scanner.nextInt();
                    list.insert(data);
                    break;
                case 2:
                    System.out.print("Enter the element to delete: ");
                    data = scanner.nextInt();
                    list.delete(data);
                    break;
                case 3:
                    System.out.print("Enter the element to find: ");
                    data = scanner.nextInt();
                    int index = list.find(data);
                    if (index == -1) {
                        System.out.println("Element not found in the list.");
                    } else {
                        System.out.println("Element found at index " + index + " in the list.");
                    }
                    break;
                case 4:
                    System.out.println("The elements in the list are: ");
                    list.Print();
                    break;
                case 5:
                    System.out.println("The elements in the list in reverse order are: ");
                    list.PrintInv();
                    break;
                case 6:
                    scanner.close();
                    System.exit(0);
                default:
                    System.out.println("Invalid choice. Please enter a valid option.");
            }
        }
    }
}
