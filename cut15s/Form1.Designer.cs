namespace FFmpegCut
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.Cut = new System.Windows.Forms.Button();
            this.PrintSelectFile = new System.Windows.Forms.Label();
            this.SelectFileButton = new System.Windows.Forms.Button();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.SelectOutDir = new System.Windows.Forms.Button();
            this.SelectSaveFolder = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // Cut
            // 
            this.Cut.Location = new System.Drawing.Point(364, 12);
            this.Cut.Name = "Cut";
            this.Cut.Size = new System.Drawing.Size(75, 23);
            this.Cut.TabIndex = 0;
            this.Cut.Text = "Порезать";
            this.Cut.UseVisualStyleBackColor = true;
            this.Cut.Click += new System.EventHandler(this.button1_Click);
            // 
            // PrintSelectFile
            // 
            this.PrintSelectFile.AutoSize = true;
            this.PrintSelectFile.Location = new System.Drawing.Point(170, 48);
            this.PrintSelectFile.Name = "PrintSelectFile";
            this.PrintSelectFile.Size = new System.Drawing.Size(0, 15);
            this.PrintSelectFile.TabIndex = 1;
            // 
            // SelectFileButton
            // 
            this.SelectFileButton.Location = new System.Drawing.Point(12, 12);
            this.SelectFileButton.Name = "SelectFileButton";
            this.SelectFileButton.Size = new System.Drawing.Size(116, 23);
            this.SelectFileButton.TabIndex = 2;
            this.SelectFileButton.Text = "1 Выбери файл ->";
            this.SelectFileButton.UseVisualStyleBackColor = true;
            this.SelectFileButton.Click += new System.EventHandler(this.button2_Click);
            // 
            // SelectOutDir
            // 
            this.SelectOutDir.Location = new System.Drawing.Point(134, 12);
            this.SelectOutDir.Name = "SelectOutDir";
            this.SelectOutDir.Size = new System.Drawing.Size(224, 23);
            this.SelectOutDir.TabIndex = 3;
            this.SelectOutDir.Text = "2 - Выбери папку для сохранения - >";
            this.SelectOutDir.UseVisualStyleBackColor = true;
            this.SelectOutDir.Click += new System.EventHandler(this.button3_Click);
            // 
            // SelectSaveFolder
            // 
            this.SelectSaveFolder.AutoSize = true;
            this.SelectSaveFolder.Location = new System.Drawing.Point(170, 74);
            this.SelectSaveFolder.Name = "SelectSaveFolder";
            this.SelectSaveFolder.Size = new System.Drawing.Size(0, 15);
            this.SelectSaveFolder.TabIndex = 4;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 102);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(38, 15);
            this.label1.TabIndex = 5;
            this.label1.Text = "label1";
            this.label1.Visible = false;
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(223, 66);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(179, 23);
            this.textBox1.TabIndex = 6;
            this.textBox1.Visible = false;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 48);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(72, 15);
            this.label2.TabIndex = 7;
            this.label2.Text = "Имя файла:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 74);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(134, 15);
            this.label3.TabIndex = 8;
            this.label3.Text = "Папка для сохранения:";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(455, 123);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.SelectSaveFolder);
            this.Controls.Add(this.SelectOutDir);
            this.Controls.Add(this.SelectFileButton);
            this.Controls.Add(this.PrintSelectFile);
            this.Controls.Add(this.Cut);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form1";
            this.Text = "Cut 15sec";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private OpenFileDialog openFileDialog1;
        private Button Cut;
        private Label PrintSelectFile;
        private Button SelectFileButton;
        private FolderBrowserDialog folderBrowserDialog1;
        private Button SelectOutDir;
        private Label SelectSaveFolder;
        private Label label1;
        private TextBox textBox1;
        private Label label2;
        private Label label3;
    }
}