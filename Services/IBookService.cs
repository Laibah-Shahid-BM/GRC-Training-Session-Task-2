using MyBookApi.Models;

namespace MyBookApi.Services;
public interface IBookService
{
    Task<IEnumerable<Book>> GetAllAsync();
    Task<Book> GetByIdAsync(int id);
}
