using System;
using System.IO;
using System.Threading;

class ValidateCsv
{
    static void Main(string[] args)
    {
        string doneFilePath = "done.txt";
        string csvFilePath = "example-output-dev-test.csv";

        while (!File.Exists(doneFilePath))
        {
            Console.WriteLine("Waiting for Ruby script to complete...");
            Thread.Sleep(10000); // Wait for 1 second before checking again
        }

        Console.WriteLine("Ruby script completed, validating CSV...");

        if (!File.Exists(csvFilePath))
        {
            Console.WriteLine("CSV file not found.");
            return;
        }

        var lines = File.ReadAllLines(csvFilePath);
        if (lines.Length == 0)
        {
            Console.WriteLine("CSV file is empty.");
            return;
        }

        var headers = lines[0].Split(',');
        if (headers.Length != 3 || headers[0] != "URL" || headers[1] != "Keyword" || headers[2] != "Sentence")
        {
            Console.WriteLine("CSV file headers are incorrect.");
            return;
        }

        Console.WriteLine("CSV file is valid.");
    }
}
