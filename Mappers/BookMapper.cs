using MyBookApi.DTOs;
using MyBookApi.Models;

namespace MyBookApi.Mappers;
public static class BookMapper
{
    public static BookResponseDTO ToResponseDTO(this Book book) => new()
    {
        Id = book.Id,
        Title = book.Title,
        Author = book.Author,
        PublishedYear = book.PublishedYear
    };
}
