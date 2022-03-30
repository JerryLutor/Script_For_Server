using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;
using System.Text.RegularExpressions;
using System.Diagnostics;

namespace FFmpegCut
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(openFileDialog1.FileName) && !string.IsNullOrEmpty(folderBrowserDialog1.SelectedPath))
            {
                ProcessStartInfo startInfo = new ProcessStartInfo();
                startInfo.CreateNoWindow = false;
                startInfo.UseShellExecute = false;
                startInfo.FileName = "ffmpeg.exe";
                //startInfo.Arguments = "-h";
                //PrintSelectFile.Text = "Start Read...";
                label1.Text = System.IO.Path.GetFileNameWithoutExtension(openFileDialog1.FileName);
                startInfo.Arguments = "-i " + openFileDialog1.FileName + " -c copy -map 0 -segment_time 15 -reset_timestamps 1 -f segment " + folderBrowserDialog1.SelectedPath + "\\"+ System.IO.Path.GetFileNameWithoutExtension(openFileDialog1.FileName) + "%03d.mp4";
                //startInfo.Arguments = "-f j -o \"" + ex1 + "\" -z 1.0 -s y " + ex2;
                //MessageBox.Show(startInfo.Arguments);

                Process.Start("explorer.exe", folderBrowserDialog1.SelectedPath);
                textBox1.Text = startInfo.Arguments;
                Process.Start(startInfo);
                SelectFileButton.Visible = true;
                SelectOutDir.Visible = true;
                folderBrowserDialog1.SelectedPath = "";
                openFileDialog1.FileName = "";
                PrintSelectFile.Text = openFileDialog1.FileName;
                SelectSaveFolder.Text = folderBrowserDialog1.SelectedPath;

                SelectFileButton.BackColor = SystemColors.ButtonFace;
                SelectFileButton.ForeColor = default(Color);
                SelectFileButton.UseVisualStyleBackColor = true;


                SelectOutDir.BackColor = SystemColors.ButtonFace;
                SelectOutDir.ForeColor = default(Color);
                SelectOutDir.UseVisualStyleBackColor = true;


            }
            else
            {
                MessageBox.Show("Выбери файл и папку");
                if  (string.IsNullOrEmpty(openFileDialog1.FileName) && !string.IsNullOrEmpty(folderBrowserDialog1.SelectedPath))
                    {
                    SelectOutDir.Visible = false;
                    SelectFileButton.BackColor = Color.Yellow;
                    }
                else if (string.IsNullOrEmpty(openFileDialog1.FileName) && string.IsNullOrEmpty(folderBrowserDialog1.SelectedPath))
                    {
                    SelectOutDir.BackColor = Color.Yellow;
                    SelectFileButton.BackColor = Color.Yellow;
                    }
                else if (!string.IsNullOrEmpty(openFileDialog1.FileName) && string.IsNullOrEmpty(folderBrowserDialog1.SelectedPath))
                {
                    SelectOutDir.BackColor = Color.Yellow;
                    SelectFileButton.Visible = false;
                }
            }

        }

        private void button2_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = "Video files (*.mp4)|*.mp4|All files (*.*)|*.*";
            if (openFileDialog1.ShowDialog() == DialogResult.Cancel)
                return;
            // получаем выбранный файл
            
            PrintSelectFile.Text = openFileDialog1.FileName;
            label1.Text = System.IO.Path.GetFileNameWithoutExtension(openFileDialog1.FileName);
            SelectFileButton.BackColor = Color.Green;
            MessageBox.Show("Файл выбран");

        }

        private void button3_Click(object sender, EventArgs e)
        {

            // Show the FolderBrowserDialog.
            DialogResult result = folderBrowserDialog1.ShowDialog();
            if (result == DialogResult.OK)
            {
                
                SelectSaveFolder.Text = folderBrowserDialog1.SelectedPath;
                SelectOutDir.BackColor = Color.Green;
                MessageBox.Show("Папка выбрана");


            }
        }


    }
}