using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Json;
using System.Net.WebSockets;
using System.Net;
using System.Configuration;
using System.Web;
using IniParser;
using IniParser.Model;
using System.Text.RegularExpressions;
using System.Resources;
using temp_outside.Properties;
using static temp_outside.Properties.Resources;


namespace temp_outside
{
    public partial class Form1 : Form
    {
        static string AppNameFile = System.Diagnostics.Process.GetCurrentProcess().ProcessName;
        private static string settingPath = AppDomain.CurrentDomain.BaseDirectory + AppNameFile + ".ini";
        public const string DEFAULT_SECTION = "app";
        public const string DEFAULT_FILENAME = "Config.ini";

        public static void CreateINIData()//create INI data file data
        {
            var data = new IniData();
            IniData createData = new IniData();
            FileIniDataParser iniParser = new FileIniDataParser();

            createData.Sections.AddSection(DEFAULT_SECTION);
            createData.Sections.GetSectionData(DEFAULT_SECTION).Comments.Add("This is the configuration file for the" + AppNameFile);
            createData.Sections.GetSectionData(DEFAULT_SECTION).Keys.AddKey("name", "Температура на улице");
            createData.Sections.GetSectionData(DEFAULT_SECTION).Keys.AddKey("url", "http://senseair.local/sensor/senseair_temperatura_out");
            createData.Sections.GetSectionData(DEFAULT_SECTION).Keys.AddKey("value", "test");
            iniParser.WriteFile(settingPath, createData);
        }
        public Form1()
        {
            InitializeComponent();
            
            if (!File.Exists(settingPath))
            {
                DialogResult result = MessageBox.Show(
            "Файла нет конфигурации. Создаю",
            "Сообщение",
            MessageBoxButtons.OK,
            MessageBoxIcon.Information,
            MessageBoxDefaultButton.Button1,
            MessageBoxOptions.DefaultDesktopOnly);

            if (result == DialogResult.OK)
               { 
               CreateINIData();
               }
            }
            //else
            //{
            //    MessageBox.Show("Файл!");
            //}



            var parser = new FileIniDataParser();
            
            IniData data = parser.ReadFile(AppNameFile + ".ini");
            string appname = data["app"]["name"];
            string appuri = data["app"]["url"];
            string appvalue = data["app"]["value"];
            this.Text = appname;
            notifyIcon1.Visible = true;
            notifyIcon1.BalloonTipTitle = appname ;
            notifyIcon1.BalloonTipText = "Читаю";
            notifyIcon1.ShowBalloonTip(10000);
            this.ShowInTaskbar = false;
            this.WindowState = FormWindowState.Minimized;
            timer2.Enabled = true;

        }


        private void button1_Click(object sender, EventArgs e)
        {
            // string ConnectionString = "http://senseair.local/sensor/senseair_temperatura_out";

            var parser = new FileIniDataParser();
            string AppNameFile = System.Diagnostics.Process.GetCurrentProcess().ProcessName;
            IniData dataini = parser.ReadFile(AppNameFile + ".ini");
            string appuri = dataini["app"]["url"];
            string appvalue = dataini["app"]["value"];

            string ConnectionString = appuri;

            using (WebClient httpClient = new WebClient())
            {
                httpClient.Encoding = Encoding.UTF8;

                List<string> data = new List<string>();
                var jsonData = httpClient.DownloadString(ConnectionString);

                dynamic result = JsonValue.Parse(jsonData);


                if (result.ContainsKey("state"))
                {
                    dynamic value = result["state"];
                    label1.Text = value.ToString();
                    notifyIcon1.Text = label1.Text;
                }

            }
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            button1_Click(null, null);
        }

        private void notifyIcon1_DoubleClick(object sender, EventArgs e)
        {
            this.Show();
            this.WindowState = FormWindowState.Normal;
            this.CenterToScreen();
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                Hide();
            }
        }

        private void выходToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void показатьToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Show();
            this.WindowState = FormWindowState.Normal;
        }

        private void скрытьToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.ShowInTaskbar = false;
            this.WindowState = FormWindowState.Minimized;
        }

        private void добавитьToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);
            key.SetValue("ESPHOME API", Application.ExecutablePath);
        }

        private void удалитьToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);
            key.DeleteValue("ESPHOME API", false);
        }

        private void timer2_Tick(object sender, EventArgs e)
        {
            button1_Click(null, null);
            timer2.Enabled = false;
        }

        private void обновитьToolStripMenuItem_Click(object sender, EventArgs e)
        {
            button1_Click(null, null);
        }
    }
}
