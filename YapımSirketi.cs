using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YapımŞirketi
{

    class Program
    {
       
        static void Search(string entity)
        {

            NpgsqlConnection connection = new NpgsqlConnection("server=localHost; port=5433; Database=Yapım Şirketi; user ID=postgres;" +
            " password=km810AAcs12!435");

            connection.Open();
            Console.WriteLine("State: " + connection.State.ToString() + "\r\n");

            string tcno;
            string queryInnerJoin = "";

            if (entity == "Oyuncu" || entity == "Personel" || entity == "Denetmen")
            {
                Console.Write("\nAramak istediğiniz kişinin T.C No'sunu giriniz: "); tcno = Console.ReadLine();

                queryInnerJoin = String.Format("SELECT * from \"Kişi\" " +
                                        "INNER JOIN \"{0}\"" +
                                        " on \"Kişi\".\"TC_NO\" = \"{0}\".\"TC_NO\" where \"Kişi\".\"TC_NO\" = '{1}'; ", entity, tcno);
                          
            }

            NpgsqlCommand command = new NpgsqlCommand(queryInnerJoin, connection);
            NpgsqlDataReader reader = command.ExecuteReader();


            while (reader.Read())
            {
                Console.WriteLine("T.C No: {0}\nAd: {1}\nSoyad: {2}\nTelNo: {3}\nMenajerNo: {5}\nAjansNo: {6}", reader.GetString(0), reader.GetString(1),
                        reader.GetString(2), reader.GetString(3), reader.GetString(4), reader.GetInt32(5), reader.GetInt32(6));
            }
            reader.Close();

            string answer;
            Console.WriteLine("\nTüm oyuncuları sıralamak ister misiniz?(e/h)"); answer = Console.ReadLine();

            if (answer == "e")
            {
                queryInnerJoin = String.Format("SELECT * from \"Kişi\" " +
                                        "INNER JOIN \"{0}\"" +
                                        " on \"Kişi\".\"TC_NO\" = \"{0}\".\"TC_NO\"", entity);

                NpgsqlCommand command1 = new NpgsqlCommand(queryInnerJoin, connection);
                NpgsqlDataReader reader1 = command.ExecuteReader();

                //Console.WriteLine($"{reader.GetName(0),-4} {reader.GetName(1),-10} {reader.GetName(2),10} {reader.GetName(3),-4} {reader.GetName(5),-4} {reader.GetName(6),-4}");

                while (reader.Read())
                {
                    string search = String.Format("T.C No: {0}\nAd: {1}\nSoyad: {2}\nTelNo: {3}\nMenajerNo: {5}\nAjansNo: {6}", reader.GetString(0), reader.GetString(1),
                            reader.GetString(2), reader.GetString(3), reader.GetString(4), reader.GetInt32(5), reader.GetInt32(6));
                    
                    ///Console.WriteLine($"{reader.GetString(0),-4} {reader.GetString(1),-10} {reader.GetString(2),10} {reader.GetString(3),-4} {reader.GetInt32(5),-4} {reader.GetInt32(6),-4}");
                    
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        if (!reader.IsDBNull(i))
                        {
                            for (int j = 0; j < 19; j++)
                            Console.Write("*");
                            Console.Write("\n");

                            Console.WriteLine(search);
                            
                        }

                    }
                }
                reader.Close();

            }

            
            connection.Close();
        }

        static void Insert(string entity) 
        {
            NpgsqlConnection connection = new NpgsqlConnection("server=localHost; port=5433; Database=Yapım Şirketi; user ID=postgres;" +
                " password=km810AAcs12!435");

            connection.Open();
            Console.WriteLine("State: " + connection.State.ToString() + "\r\n");
            string query;
            string tcno, isim, soyisim, telno, ajans, menajerAdı, menajerSoyadı, menajerTelNo;

            string quit = "e";

            do
            {
                switch (entity)
                {

                    case "Oyuncu":
                        Console.Write("T.C No:"); tcno = Console.ReadLine();
                        Console.Write("İsim:"); isim = Console.ReadLine();
                        Console.Write("Soyisim:"); soyisim = Console.ReadLine();
                        Console.Write("tel No:"); telno = Console.ReadLine();
                        Console.Write("Ajans:"); ajans = Console.ReadLine();
                        Console.Write("Menajer Adı:"); menajerAdı = Console.ReadLine();
                        Console.Write("Menajer Soyadı:"); menajerSoyadı = Console.ReadLine();
                        Console.Write("Menajer Tel No:"); menajerTelNo = Console.ReadLine();

                        query = String.Format("select * from oyuncu_insert('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}')", tcno, isim, soyisim, telno, ajans, menajerAdı, menajerSoyadı, menajerTelNo);
                       
                        NpgsqlCommand command = new NpgsqlCommand(query, connection);
                        command.ExecuteNonQuery();

                        Console.WriteLine("Çıkış yapmak ister misiniz(e/h): "); quit = Console.ReadLine();

                            break;
                        case "Personel":
                            break;
                        case "Denetmen":
                            break;
                        case "Film":
                            break;
                        case "Dizi":
                            break;
                        case "Reklam":
                            break;
                        default:
                            break;

                }

            } while (quit != "e");

        }

        static void Delete(string entity) 
        {
            NpgsqlConnection connection = new NpgsqlConnection("server=localHost; port=5433; Database=Yapım Şirketi; user ID=postgres;" +
                  " password=km810AAcs12!435");

            connection.Open();
            Console.WriteLine("State: " + connection.State.ToString() + "\r\n");
            string delete;
            string answer;

            switch(entity)
            {
                case "Oyuncu":
                    Console.Write("\nSilinecek kişinin T.C No'sunu giriniz: "); answer = Console.ReadLine();

                    delete = "delete from \"Kişi\" where \"TC_NO\" = '" + answer + "'";

                    NpgsqlCommand command = new NpgsqlCommand(delete, connection);

                    command.ExecuteNonQuery();
                    break;
                case "Yapım":
                    Console.Write("\nSilinecek yapımın yapım No'sunu giriniz: "); answer = Console.ReadLine();

                    delete = "delete from \"Yapım\" where \"yapımNo\" = '" + answer + "'";

                    NpgsqlCommand command1 = new NpgsqlCommand(delete, connection);

                    command1.ExecuteNonQuery();

                    break;

            }          

        }

        static void Update(string entity) 
        {
            string connString = "server=localHost; port=5433; Database=Yapım Şirketi; user ID=postgres;" +
            " password=km810AAcs12!435";

            string quit = "e";

            do
            {
                using (var conn = new NpgsqlConnection(connString))
                {

                    Console.Out.WriteLine("Opening connection");
                    conn.Open();

                    string ad;
                    string soyad;
                    string tcno;

                    if (entity == "Oyuncu" || entity == "Personel" || entity == "Denetmen")
                    {


                        Console.WriteLine("Yen ad ve soyadını giriniz\nAd:"); ad = Console.ReadLine(); Console.WriteLine("Soyad:"); soyad = Console.ReadLine();
                        Console.WriteLine("Güncellenecek olan kişinin T.C No'sunu girin: "); tcno = Console.ReadLine();

                        using (var command = new NpgsqlCommand(String.Format("UPDATE \"Kişi\" SET \"ad\" = '{0}' , \"soyad\" = '{1}' WHERE \"TC_NO\" = '{2}'", ad, soyad, tcno), conn))
                        {
                            command.ExecuteNonQuery();
                        }
                    }
                    Console.WriteLine("Çıkış yapmak ister misiniz(e/h): "); quit = Console.ReadLine();

                }
            } while (quit != "e");          

        }

        static void Main(string[] args)
        {

            string quit = "e";

            do
            {
                Console.WriteLine("Ne aramak istiyorsunuz?\n(Personel, Denetmen, Oyuncu, AnlaşmalıAjans, Menajer, Film, Reklam, Dizi, TeknikEkipman, Sponsor, KanalTemsilcisi)");
                string entity;
                entity = Console.ReadLine();

                Console.WriteLine("Hangi işlemi yapmak istiyorsunuz? (Arama[1], Ekleme[2], Silme[3]), Güncelleme[4]");
                string answer;
                answer = Console.ReadLine();
                switch (answer)
                {
                    case "1":
                        Search(entity);
                        break;
                    case "2":
                        Insert(entity);
                        break;
                    case "3":
                        Delete(entity);
                        break;
                    case "4":
                        Update(entity);
                        break;
                    default:
                        break;
                }
                Console.WriteLine("Çıkış yapmak ister misiniz(e/h): "); quit = Console.ReadLine();

            } while (quit != "e");
           
            Console.ReadLine(); 
        } 
    } 

    
}
