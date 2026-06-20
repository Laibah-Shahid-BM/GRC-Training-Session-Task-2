namespace MyBookApi.Exceptions;
public class BookNotFoundException : Exception
{
    public int BookId { get; }

    public BookNotFoundException(int bookId)
        : base($"Book with id {bookId} was not found.")
    {
        BookId = bookId;
    }
}
