using MyBookApi.Exceptions;
using MyBookApi.Models;

namespace MyBookApi.Services;

public class BookService : IBookService
{
    private readonly List<Book> _books = new()
    {
        new Book { Id = 1, Title = "The Pragmatic Programmer", Author = "Andrew Hunt, David Thomas", PublishedYear = 1999 },
        new Book { Id = 2, Title = "Clean Code", Author = "Robert C. Martin", PublishedYear = 2008 },
        new Book { Id = 3, Title = "Designing Data-Intensive Applications", Author = "Martin Kleppmann", PublishedYear = 2017 }
    };

    public Task<IEnumerable<Book>> GetAllAsync()
        => Task.FromResult(_books.AsEnumerable());

    public Task<Book> GetByIdAsync(int id)
    {
        var book = _books.FirstOrDefault(b => b.Id == id);

        if (book is null)
            throw new BookNotFoundException(id);

        return Task.FromResult(book);
    }
}
