using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Threading;




class WavReader
{
    private byte[] wav;
    private double [] data;
    private int pos;

    public int GetPos()
    {
        return pos;
    }
    public byte[] GetWav()
    {
        return wav;
    }

    public double[] GetData()
    {
        return data;
    }
    static double BytesToDouble(byte firstByte, byte secondByte)
    {
        // convert two bytes to one short (little endian)
        short s = (short)((secondByte << 8) | firstByte);
        // convert to range from -1 to (just below) 1
        return s;
    }

    public void Read(string filename)
    {
        wav = File.ReadAllBytes(filename);

        int tPos = 12;

        // Keep iterating until we find the data chunk (i.e. 64 61 74 61 ...... (i.e. 100 97 116 97 in decimal))
        while (!(wav[tPos] == 100 && wav[tPos + 1] == 97 && wav[tPos + 2] == 116 && wav[tPos + 3] == 97))
        {
            tPos += 4;
            int chunkSize = wav[tPos] + wav[tPos + 1] * 256 + wav[tPos + 2] * 65536 + wav[tPos + 3] * 16777216;
            tPos += 4 + chunkSize;
        }
        
        tPos += 8;
        pos = tPos;
        // Pos is now positioned to start of actual sound data.
        int samples = (wav.Length - tPos)/2;     // 2 bytes per sample (16 bit sound mono)

        data = new double[samples];

        int i = 0;
        while (tPos < wav.Length)
        {
            data[i] = BytesToDouble(wav[tPos], wav[tPos + 1]);
            tPos += 2;
            i++;
        }
    }

    public void DoublesToBytes()
    {
        int it = 0;
        for (int i = 0; i < data.Length; i++)
        {
            wav[pos + it + 1] = (byte)((data[i]) / 256);
            wav[pos + it] = (byte)((data[i]) % 256);
            it += 2;
        }
    }

    public void Write()
    {
        string filename = "output.wav"; //todo usun
        File.WriteAllBytes(filename, wav);
    }
}

namespace JaProj
{
    public partial class MainWindow : Window
    {
        public double[] coeffs = {0.000000000000000000,
0.0000000,
0.000000,
0.000000,
-0.000000065499698995,
-0.000004837010300024,
-0.000010542377956247,
-0.000012285752450768,
-0.000005347005694730,
0.000010560139237500,
0.000028714760029971,
0.000037199792346979,
0.000025380895836667,
-0.000007990386604173,
-0.000050219293634985,
-0.000077975287944411,
-0.000068766853739606,
-0.000015570314727995,
0.000063867613642715,
0.000130464292462819,
0.000141354923114592,
0.000074554099638586,
-0.000052403446219210,
-0.000182543631932819,
-0.000242768266599860,
-0.000182173680212591,
-0.000006444766444419,
0.000212496618574794,
0.000362553472775911,
0.000345926548888720,
0.000136920809030164,
-0.000188950776705267,
-0.000476664306357331,
-0.000561905176949339,
-0.000359858301633320,
0.000073332765483582,
0.000545481074976138,
0.000808838817636708,
0.000685166248814047,
0.000174491616239670,
-0.000514682658252118,
-0.001043293648207315,
-0.001103085653475217,
-0.000587326029682841,
0.000320047425259988,
0.001197703910156720,
0.001575774903036565,
0.001179237725499382,
0.000103353776002413,
-0.001182758539145497,
-0.002031186545872029,
-0.001933186613301264,
-0.000808001825033265,
0.000895073025232106,
0.002361170017577986,
0.002789818917798504,
0.001818215292501871,
-0.000230096215462736,
-0.002425163870575281,
-0.003639661081547044,
-0.003114070197323305,
-0.000900989190500731,
0.002059715986306285,
0.004320378826821467,
0.004617440815722668,
0.002552759423426335,
-0.001092460575489725,
-0.004619353105850151,
-0.006182134273640526,
-0.004728641140741932,
-0.000642859190673150,
0.004279327525278419,
0.007588370161037711,
0.007369058520778860,
0.003296428347289233,
-0.003000573180480896,
-0.008538107131431511,
-0.010347643423598594,
-0.007008170263789290,
0.000424304950543991,
0.008639391609587857,
0.013477380497324795,
0.011951495636846032,
0.003940734931294413,
-0.007345396537287986,
-0.016526910148427491,
-0.018475574589106737,
-0.010964834306414786,
0.003733980690781678,
0.019245352941473434,
0.027573080505437879,
0.022791240273712186,
0.004379464642123541,
-0.021392321708416151,
-0.042929804865912684,
-0.047359504691036516,
-0.025720081564983437,
0.022768613963026301,
0.089218436999313963,
0.157211578653327050,
0.207976960094949620,
0.226758009876731698,
0.207976960094949620,
0.157211578653327050,
0.089218436999313963,
0.022768613963026301,
-0.025720081564983441,
-0.047359504691036516,
-0.042929804865912691,
-0.021392321708416151,
0.004379464642123541,
0.022791240273712189,
0.027573080505437882,
0.019245352941473434,
0.003733980690781678,
-0.010964834306414786,
-0.018475574589106741,
-0.016526910148427491,
-0.007345396537287987,
0.003940734931294413,
0.011951495636846035,
0.013477380497324795,
0.008639391609587859,
0.000424304950543991,
-0.007008170263789294,
-0.010347643423598594,
-0.008538107131431509,
-0.003000573180480897,
0.003296428347289234,
0.007369058520778863,
0.007588370161037714,
0.004279327525278418,
-0.000642859190673150,
-0.004728641140741934,
-0.006182134273640527,
-0.004619353105850152,
-0.001092460575489724,
0.002552759423426333,
0.004617440815722671,
0.004320378826821467,
0.002059715986306285,
-0.000900989190500731,
-0.003114070197323306,
-0.003639661081547044,
-0.002425163870575282,
-0.000230096215462736,
0.001818215292501871,
0.002789818917798505,
0.002361170017577986,
0.000895073025232107,
-0.000808001825033266,
-0.001933186613301265,
-0.002031186545872029,
-0.001182758539145497,
0.000103353776002413,
0.001179237725499382,
0.001575774903036566,
0.001197703910156720,
0.000320047425259988,
-0.000587326029682841,
-0.001103085653475219,
-0.001043293648207316,
-0.000514682658252118,
0.000174491616239670,
0.000685166248814048,
0.000808838817636709,
0.000545481074976138,
0.000073332765483582,
-0.000359858301633320,
-0.000561905176949339,
-0.000476664306357331,
-0.000188950776705267,
0.000136920809030164,
0.000345926548888720,
0.000362553472775912,
0.000212496618574795,
-0.000006444766444419,
-0.000182173680212591,
-0.000242768266599860,
-0.000182543631932819,
-0.000052403446219210,
0.000074554099638586,
0.000141354923114592,
0.000130464292462819,
0.000063867613642715,
-0.000015570314727995,
-0.000068766853739606,
-0.000077975287944411,
-0.000050219293634986,
-0.000007990386604173,
0.000025380895836667,
0.000037199792346979,
0.000028714760029972,
0.000010560139237500,
-0.000005347005694730,
-0.000012285752450768,
-0.000010542377956247,
-0.000004837010300024,
-0.000000065499698995,
0.000000,
0.000000,
0.0000000,
0.000000000000000000};

        public string filename = " ";
        double[] ogData;
        public int coeffsSize = 203;
        public MainWindow()
        {
            InitializeComponent();
    
        }
        
        [DllImport(@"..\..\..\..\..\x64\Release\JaProjCppDll.dll")]
        private unsafe static extern void processData(double * data, int num, double [] coeffs, double[] ogData, int start);

        

        [DllImport(@"..\..\..\..\..\x64\Release\AsmDll.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        private unsafe static extern void procData(double* data, int num, double [] coeffs, double [] ogData, int start);

        private void NumberValidation(object sender, TextCompositionEventArgs e)
    {
        Regex regex = new Regex("[^0-9]+");
        e.Handled = regex.IsMatch(e.Text);
    }

       
    private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void Select_File(object sender, RoutedEventArgs e)
        {
            // Configure open file dialog box
            var dialog = new Microsoft.Win32.OpenFileDialog();
            dialog.DefaultExt = ".wav"; // Default file extension
            dialog.Filter = "Wav files (.wav)|*.wav"; // Filter files by extension

            // Show open file dialog box
            bool? result = dialog.ShowDialog();

            // Process open file dialog box results
            if (result == true)
            {
                // Open document
                filename = dialog.FileName;
            }
        }

        public void FillData(double [] data)
        {
            for(int i = data.Length-1; i > data.Length - coeffsSize - 1; i--)
            {
                data[i] = 0;
            }
        }
        
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            
            var watch = new System.Diagnostics.Stopwatch();
            int threads = int.Parse(Threads.Text);
            Thread[] threadTab = new Thread[threads];
            WavReader reader = new WavReader();

     
            reader.Read(filename);

           
            int sizeOfOne = reader.GetData().Length / threads;

            ogData = new double[reader.GetData().Length + coeffsSize];

            reader.GetData().CopyTo(ogData, 0);

            FillData(ogData);
            
            
            if (asmChoose.IsChecked == true && filename != " ")
            {
                watch.Start();
                for (int i = 0; i < threads; i++)
                {
                    int j = i;

                    threadTab[j] = new Thread(() => ThreadFunc(reader.GetData(), sizeOfOne * j,sizeOfOne * (j+1)));


                }

                for (int i = 0; i < threads; i++)
                {
                    int j = i;
                    threadTab[j].Start();
                }

                for (int i = 0; i < threads; i++)
                {
                    int j = i;
                    threadTab[j].Join();
                }

                watch.Stop();

                timer.Content = watch.ElapsedMilliseconds;

            }
           else if(filename != " ")
            {
                watch.Start();

                for (int i = 0; i < threads; i++)
                {
                    int j = i;
                    
                    threadTab[j] = new Thread(() => ThreadFuncCpp(reader.GetData(), sizeOfOne * j, sizeOfOne * (j + 1)));

                }

                for (int i = 0; i < threads; i++)
                {
                    int j = i;
                    threadTab[j].Start();
                }

                for (int i = 0; i < threads; i++)
                {
                    int j = i;
                    threadTab[j].Join();
                }

                watch.Stop();

                timer.Content = watch.ElapsedMilliseconds;

            }


            reader.DoublesToBytes();
            reader.Write();


        }

        private void Asm_checked(object sender, RoutedEventArgs e)
        {
            
            if(cppChoose.IsChecked == true)
            {
                cppChoose.IsChecked = false;
            }
        }

        private void Cpp_checked(object sender, RoutedEventArgs e)
        {
            if(asmChoose.IsChecked == true)
            {
                asmChoose.IsChecked = false;
            }
        }

        private unsafe void ThreadFunc(double[] samples, int start, int end)
        {
            int num = end - start;

            fixed(double * ptr = &samples[start])
            {
                procData(ptr, num, coeffs, ogData, start*8);
            }
            

        }

        private unsafe void ThreadFuncCpp(double[] samples, int start, int end)
        {
            int num = end - start;

            fixed (double* ptr = &samples[start])
            {
                processData(ptr, num, coeffs, ogData, start);
            }
        }
    }
}
